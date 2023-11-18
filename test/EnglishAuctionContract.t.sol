// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../../src/EnglishAuctionContract.sol";

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";

contract MyNFT is ERC721URIStorage {

    uint256 public _tokenId;

    constructor() ERC721("MyNFT", "MNFT") {}

    function mintNFT(address recipient, string memory tokenURI) public returns (uint256) {
        _tokenId++;
        uint256 newItemId = _tokenId;
        _mint(recipient, newItemId);
        _setTokenURI(newItemId, tokenURI);
        return newItemId;
    }
}



contract EnglishAuctionContractTest {

    EnglishAuctionContract public auctionContract;
    MyNFT public nftContract;
    address public testSeller = address(0x1);

    function setUp() public {
        nftContract = new MyNFT();
        auctionContract = new EnglishAuctionContract();
        vm.prank(testSeller);
        nftContract.mintNFT(testSeller, "someURI");

        vm.prank(testSeller);
        auctionContract.depositNFT(100, 50, address(nftContract), nftContract.tokendId());
    }

}