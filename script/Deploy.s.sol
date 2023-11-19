// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "forge-std/Script.sol";
import "../src/EnglishAuctionContract.sol";

contract Deploy is Script {
    function run() public {
        vm.startBroadcast();
        EnglishAuctionContract auctionContract = new EnglishAuctionContract();
        vm.deployContract(auctionContract);
    }
}