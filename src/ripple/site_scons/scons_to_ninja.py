# Copyright (c) 2014 The Native Client Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.
import atexit
import os
import sys
import SCons.Action
# This implements a Ninja backend for SCons.  This allows SCons to be used
# as a Ninja file generator, similar to how Gyp will generate Ninja files.
#
# This is a way to bypass SCons's slow startup time.  After running SCons
# to generate a Ninja file (which is fairly slow), you can rebuild targets
# quickly using Ninja, as long as the .scons files haven't changed.
#
# The implementation is fairly hacky: It hooks PRINT_CMD_LINE_FUNC to
# discover the build commands that SCons would normally run.
#
# A cleaner implementation would traverse the node graph instead.
# Traversing the node graph is itself straightforward, but finding the
# command associated with a node is not -- I couldn't figure out how to do
# that.
# This is necessary to handle SCons's "variant dir" feature.  The filename
# associated with a Scons node can be ambiguous: it might come from the
# build dir or the source dir.
def GetRealNode(node):
  src = node.srcnode()
  if src.stat() is not None:
    return src
  return node
def GenerateNinjaFile(envs, dest_file):
  # Tell SCons not to run any commands, just report what would be run.
  for e in envs:
    e.SetOption('no_exec', True)
    # Tell SCons that everything needs rebuilding.
    e.Decider(lambda dependency, target, prev_ni: True)
  # Use a list to ensure that the output is ordered deterministically.
  node_list = []
  node_map = {}
  def CustomCommandPrinter(cmd, targets, source, env):
    assert len(targets) == 1, len(targets)
    node = targets[0]
    # There can sometimes be multiple commands per target (e.g. ar+ranlib).
    # We must collect these together to output a single Ninja rule.
    if node not in node_map:
      node_list.append(node)
    node_map.setdefault(node, []).append(cmd)
  for e in envs:
    e.Append(PRINT_CMD_LINE_FUNC=CustomCommandPrinter)
  def WriteFile():
    dest_temp = '%s.tmp' % dest_file
    ninja_fh = open(dest_temp, 'w')
    ninja_fh.write("""\
# Generated by scons_to_ninja.py
# Generic rule for handling any command.
rule cmd
  command = $cmd
# NaCl overrides SCons's Install() step to create hard links, for speed.
# To coexist with that, we must remove the file before copying, otherwise
# cp complains the source and dest "are the same file".  We also create
# hard links here (with -l) for speed.
rule install
  command = rm -f $out && cp -l $in $out
""")
    for node in node_list:
      dest_path = node.get_path()
      cmds = node_map[node]
      deps = [GetRealNode(dep).get_path() for dep in node.all_children()]
      action = node.builder.action
      if type(action) == SCons.Action.FunctionAction:
        funcname = action.function_name()
        if funcname == 'installFunc':
          assert len(deps) == 1, len(deps)
          ninja_fh.write('\nbuild %s: install %s\n'
                         % (dest_path, ' '.join(deps)))
          continue
        else:
          sys.stderr.write('Unknown FunctionAction, %r: skipping target %r\n'
                           % (funcname, dest_path))
          continue
      ninja_fh.write('\nbuild %s: cmd %s\n'
                     % (dest_path, ' '.join(deps)))
      ninja_fh.write('  cmd = %s\n' % ' && '.join(cmds))
    # Make the result file visible atomically.
    os.rename(dest_temp, dest_file)
  atexit.register(WriteFile)
