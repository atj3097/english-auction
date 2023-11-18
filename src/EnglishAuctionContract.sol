// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;
// A seller calls deposit() to deposit an NFT into a contract along with a deadline and a reserve price. Buyers can bid on that NFT up until the deadline, and the highest bid wins. If the reserve price is not met, the NFT is not sold. Multiple auctions can happen at the same time. Buyers who did not win can withdraw their bid. The winner is not able to withdraw their bid and must complete the trade to buy the NFT. The seller can also end the auction by calling sellerEndAuction() which only works after expiration, and if the reserve is met. The winner will be transferred the NFT and the seller will receive the Ethereum.
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";

contract EnglishAuctionContract {

    uint256 public deadline;
    uint256 public reservePrice;

    struct Bid {
        address bidder;
        uint256 amount;
    }

    struct Auction {
        address seller;
        uint256 deadline;
        uint256 reservePrice;
        bool ended;
        Bid highestBid;
        mapping(address => Bid) bids;
    }

    constructor(uint256 _deadline, uint256 _reservePrice) {
        deadline = _deadline;
        reservePrice = _reservePrice;
    }

    function depositNFT(uint256 _deadline, uint256 _reservePrice) public {

    }

}
