// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../../src/EnglishAuctionContract.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "forge-std/console.sol";


contract MyNFT is ERC721URIStorage {

    uint256 public tokenId = 0;

    constructor() ERC721("MyNFT", "MNFT") {}

    function mintNFT(address recipient, string memory tokenURI) public returns (uint256) {
        tokenId++;
        uint256 newItemId = tokenId;
        _mint(recipient, newItemId);
        _setTokenURI(newItemId, tokenURI);
        return newItemId;
    }
}



contract EnglishAuctionContractTest is Test {

    EnglishAuctionContract public auctionContract;
    MyNFT public nftContract;
    address public testSeller = address(0x1);
    uint256 public testTokenId;

    function setUp() public {
        nftContract = new MyNFT();
        auctionContract = new EnglishAuctionContract();

        vm.prank(testSeller);
        uint256 mintedTokenId = nftContract.mintNFT(testSeller, "someURI");
        testTokenId = mintedTokenId;
        console.log("mintedTokenId", mintedTokenId);

        vm.prank(testSeller);
        nftContract.approve(address(auctionContract), mintedTokenId);

        vm.prank(testSeller);
        auctionContract.depositNFT(100, 50, address(nftContract), mintedTokenId);
    }

    function testDepositNFT() public {
        (address seller, uint256 deadline, uint256 reservePrice, bool ended, EnglishAuctionContract.Bid memory highestBid, address nft) = auctionContract.tokenIdToAuction(1);
        assertEq(seller, testSeller);
        assertEq(deadline, 100);
        assertEq(reservePrice, 50);
        assertEq(ended, false);
        assertEq(highestBid.bidder, address(0));
        assertEq(highestBid.amount, 0);
        assertEq(address(nft), address(nftContract));
    }

    function testBid() public {
        vm.prank(address(this));
        auctionContract.bid{value: 120}(testTokenId);
        (address seller, uint256 deadline, uint256 reservePrice, bool ended, EnglishAuctionContract.Bid memory highestBid, address nft) = auctionContract.tokenIdToAuction(0);
        assertEq(seller, testSeller);
        assertEq(deadline, 100);
        assertEq(reservePrice, 50);
        assertEq(ended, false);
        assertEq(highestBid.bidder, address(this));
        assertEq(highestBid.amount, 120);
        assertEq(address(nft), address(nftContract));
    }

    function testWithdrawBid() public {
        vm.prank(address(this));
        auctionContract.bid{value: 120}(testTokenId);
        vm.prank(address(this));
        auctionContract.withdrawBid(testTokenId);
        (address seller, uint256 deadline, uint256 reservePrice, bool ended, EnglishAuctionContract.Bid memory highestBid, address nft) = auctionContract.tokenIdToAuction(0);
        assertEq(seller, testSeller);
        assertEq(deadline, 100);
        assertEq(reservePrice, 50);
        assertEq(ended, false);
        assertEq(highestBid.bidder, address(0));
        assertEq(highestBid.amount, 0);
        assertEq(address(nft), address(nftContract));
    }

    function testWithdrawBidFail() public {
        vm.prank(address(this));
        auctionContract.bid{value: 120}(testTokenId);
        vm.prank(address(this));
        auctionContract.withdrawBid(testTokenId);
        vm.prank(address(this));
        auctionContract.withdrawBid(testTokenId);
    }



}