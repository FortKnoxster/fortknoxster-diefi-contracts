# FortKnoxster DieFi Contracts

FortKnoxster DieFi smart contracts on Polygon for managing a decentralized Dead Man's Switch using gasless meta transactions.

To create a policy for the DieFi Dead Man's Switch, the client browser/user prepares and signs an [EIP-2771](https://eips.ethereum.org/EIPS/eip-2771) meta transaction using [EIP-712](https://eips.ethereum.org/EIPS/eip-712) typed structured data hashing and signing, and sends it to a relayer/payer. The relayer verifies the signed transaction and sends it to the DieFiForwarder which  also verifies the client signed transaction. The DieFiForwarder executes the transaction sending it to the DieFiPolicy which in turn sends it to the Threshold's SubscriptionManager.

The final policy created, consists of time-based conditions according to users' Dead Man's Switch timer settings and the size of the threshold shares on the Threshold decentralized network which enforces the policy conditions.


## Mumbai testnet

The DieFiForwarder contract is located here:

https://mumbai.polygonscan.com/address/0x9345D4F40D9aB53569A39696c9C18828d455b5C8

The DieFiPolicy contract is located here:

https://mumbai.polygonscan.com/address/0xEaD0e3a0Fa0Fb2b88fB18A67cCeC2c844800DeF9

The NuCypher/Threshold SubscriptionManager is located here:

https://mumbai.polygonscan.com/address/0xb9015d7b35ce7c81dde38ef7136baa3b1044f313


## Polygon mainnet

The DieFiForwarder contract is located here:

https://polygonscan.com/address/0x7bebcD419573313A9A0421bF30c6075F15a70deb

The DieFiPolicy contract is located here:

https://polygonscan.com/address/0x8239c81dFC033Db64B81df1B180BA456E204e4DA

The NuCypher/Threshold SubscriptionManager is located here:

https://polygonscan.com/address/0xB0194073421192F6Cf38d72c791Be8729721A0b3

## Deployment notes

Deploy contracts

```
truffle migrate --network matic --reset
```

Verify contracts on Polygonscan.com

```
truffle run verify DieFiForwarder DieFiPolicy --network matic
```