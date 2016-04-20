#/bin/bash
vagrant ssh one -c "sudo service rippled2 start"
vagrant ssh two -c "sudo service rippled2 start"
vagrant ssh three -c "sudo service rippled2 start"

