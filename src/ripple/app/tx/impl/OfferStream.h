//------------------------------------------------------------------------------
/*
    This file is part of rippled: https://github.com/ripple/rippled
    Copyright (c) 2014 Ripple Labs Inc.

    Permission to use, copy, modify, and/or distribute this software for any
    purpose  with  or without fee is hereby granted, provided that the above
    copyright notice and this permission notice appear in all copies.

    THE  SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
    WITH  REGARD  TO  THIS  SOFTWARE  INCLUDING  ALL  IMPLIED  WARRANTIES  OF
    MERCHANTABILITY  AND  FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
    ANY  SPECIAL ,  DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
    WHATSOEVER  RESULTING  FROM  LOSS  OF USE, DATA OR PROFITS, WHETHER IN AN
    ACTION  OF  CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
    OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
*/
//==============================================================================

#ifndef RIPPLE_APP_BOOK_OFFERSTREAM_H_INCLUDED
#define RIPPLE_APP_BOOK_OFFERSTREAM_H_INCLUDED

#include <ripple/app/tx/impl/BookTip.h>
#include <ripple/app/tx/impl/Offer.h>   
#include <ripple/ledger/View.h>
#include <ripple/protocol/Quality.h>
#include <beast/utility/Journal.h>
#include <beast/utility/noexcept.h>
#include <functional>

namespace ripple {

/** Presents and consumes the offers in an order book.

    Two `View` objects accumulate changes to the ledger. `view`
    is applied when the calling transaction succeeds. If the calling
    transaction fails, then `view_cancel` is applied.

    Certain invalid offers are automatically removed:
        - Offers with missing ledger entries
        - Offers that expired
        - Offers found unfunded:
            An offer is found unfunded when the corresponding balance is zero
            and the caller has not modified the balance. This is accomplished
            by also looking up the balance in the cancel view.

    When an offer is removed, it is removed from both views. This grooms the
    order book regardless of whether or not the transaction is successful.
*/
class OfferStream
{
private:
    beast::Journal j_;
    std::reference_wrapper <View> m_view;
    std::reference_wrapper <View> m_view_cancel;
    Book m_book;
    Clock::time_point m_when;
    BookTip m_tip;
    Offer m_offer;
    Config const& config_;

    void
    erase (View& view);

public:
    OfferStream (View& view, View& view_cancel,
        BookRef book, Clock::time_point when,
            Config const& config,
                beast::Journal journal);

    View&
    view () noexcept
    {
        return m_view;
    }

    View&
    view_cancel () noexcept
    {
        return m_view_cancel;
    }

    Book const&
    book () const noexcept
    {
        return m_book;
    }

    /** Returns the offer at the tip of the order book.
        Offers are always presented in decreasing quality.
        Only valid if step() returned `true`.
    */
    Offer const&
    tip () const
    {
        return m_offer;
    }

    /** Advance to the next valid offer.
        This automatically removes:
            - Offers with missing ledger entries
            - Offers found unfunded
            - expired offers
        @return `true` if there is a valid offer.
    */
    bool
    step ();
};

}

#endif

