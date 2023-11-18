// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;
// A seller calls deposit() to deposit an NFT into a contract along with a deadline and a reserve price. Buyers can bid on that NFT up until the deadline, and the highest bid wins. If the reserve price is not met, the NFT is not sold. Multiple auctions can happen at the same time. Buyers who did not win can withdraw their bid. The winner is not able to withdraw their bid and must complete the trade to buy the NFT. The seller can also end the auction by calling sellerEndAuction() which only works after expiration, and if the reserve is met. The winner will be transferred the NFT and the seller will receive the Ethereum.
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";

contract EnglishAuctionContract is IERC721Receiver {

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
        address nft;
    }
    mapping (uint256 => Auction) public tokenIdToAuction;


    mapping (address => uint256) public ownerToNFTId;

    constructor() {
    }

    function depositNFT(uint256 _deadline, uint256 _reservePrice, address nft, uint256 tokenId) public {
        require(_deadline > block.timestamp, "Deadline must be in the future");
        require(IERC721(nft).ownerOf(tokenId) == msg.sender, "You must own the NFT");
        Auction storage auction = tokenIdToAuction[tokenId];
        auction.seller = msg.sender;
        auction.deadline = _deadline;
        auction.reservePrice = _reservePrice;
        auction.ended = false;
        auction.highestBid = Bid(address(0), 0);
        auction.nft = nft;
        IERC721(nft).transferFrom(msg.sender, address(this), tokenId);
    }


    function bid(uint256 _tokenId) public payable {
        Auction storage auction = tokenIdToAuction[_tokenId];
        require(auction.seller != address(0), "Auction does not exist");
        require(block.timestamp < auction.deadline, "Auction is over");
        require(msg.value > auction.highestBid.amount, "Bid is too low");
        require(msg.value > auction.reservePrice, "Bid is too low");
        auction.highestBid = Bid(msg.sender, msg.value);
        auction.bids[msg.sender] = Bid(msg.sender, msg.value);
    }

    function currentHighestBid(uint256 _tokenId) public view returns (uint256) {
        Auction storage auction = tokenIdToAuction[_tokenId];
        return auction.highestBid.amount;
    }

    function withdrawBid(uint256 _tokenId) public {
        Auction storage auction = tokenIdToAuction[_tokenId];
        require(auction.seller != address(0), "Auction does not exist");
        require(block.timestamp > auction.deadline, "Auction is not over");
        require(auction.bids[msg.sender].amount > 0, "You have not bid");
        require(auction.highestBid.bidder != msg.sender, "You are the highest bidder");
        uint256 amount = auction.bids[msg.sender].amount;
        auction.bids[msg.sender].amount = 0;
        payable(msg.sender).transfer(amount);
    }

    function completeTrade(uint256 _tokenId) public {
        Auction storage auction = tokenIdToAuction[_tokenId];
        address nft = auction.nft;
        require(auction.seller != address(0), "Auction does not exist");
        require(block.timestamp > auction.deadline, "Auction is not over");
        require(auction.highestBid.bidder == msg.sender, "You are not the highest bidder");
        require(auction.ended == false, "Auction has already ended");
        auction.ended = true;
        IERC721(nft).transferFrom(address(this), msg.sender, _tokenId);
        payable(auction.seller).transfer(auction.highestBid.amount);
    }

}
