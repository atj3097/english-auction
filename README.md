## English Auction

A seller calls deposit() to deposit an NFT into a contract along with a deadline and a reserve price. Buyers can bid on that NFT up until the deadline, and the highest bid wins. If the reserve price is not met, the NFT is not sold. Multiple auctions can happen at the same time. Buyers who did not win can withdraw their bid. The winner is not able to withdraw their bid and must complete the trade to buy the NFT. The seller can also end the auction by calling sellerEndAuction() which only works after expiration, and if the reserve is met. The winner will be transferred the NFT and the seller will receive the Ethereum.

Foundry consists of:

-   **Forge**: Ethereum testing framework (like Truffle, Hardhat and DappTools).
-   **Cast**: Swiss army knife for interacting with EVM smart contracts, sending transactions and getting chain data.
-   **Anvil**: Local Ethereum node, akin to Ganache, Hardhat Network.
-   **Chisel**: Fast, utilitarian, and verbose solidity REPL.

## Documentation

https://book.getfoundry.sh/

## Usage

### Build

```shell
$ forge build
```

### Test

```shell
$ forge test
```

### Format

```shell
$ forge fmt
```

### Gas Snapshots

```shell
$ forge snapshot
```

### Anvil

```shell
$ anvil
```

### Deploy

```shell
$ forge script script/Counter.s.sol:CounterScript --rpc-url <your_rpc_url> --private-key <your_private_key>
```

### Cast

```shell
$ cast <subcommand>
```

### Help

```shell
$ forge --help
$ anvil --help
$ cast --help
```
