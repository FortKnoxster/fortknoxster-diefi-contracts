# FortKnoxster Diefi Contracts

FortKnoxster DieFi smart contract on Polygon for managing a decentralized Dead Man's Switch using gasless meta transactions.

To create a policy for the DieFi Dead Man's Switch, the client browser/user prepares and signs an [EIP-2771](https://eips.ethereum.org/EIPS/eip-2771) meta transaction using [EIP-712](https://eips.ethereum.org/EIPS/eip-712) typed structured data hashing and signing, and sends it to a relayer/payer. The relayer verifies the signed transaction and sends it to the DieFiForwarder which verifies that the relayer is trusted and also verifies the client signed transaction. The DieFiForwarder executes the transaction sending it to the DieFiPolicy which in turn sends it to the Threshold's SubscriptionManager.

The final policy created, consists of time-based conditions according to the Dead Man's Switch timer settings and the size of the threshold shares on the Threshold decentralized network which enforces the policy conditions.


## Mumbai testnet

The DieFiForwarder contract is located here:

https://mumbai.polygonscan.com/address/0xF33a2809677f2638066D05e73169DeB4dB34F100

The DieFiPolicy contract is located here:

https://mumbai.polygonscan.com/address/0xDF079200668435f53B6cDaE47fD5fF86da45fF78

The NuCypher/Threshold SubscriptionManager is located here:

https://mumbai.polygonscan.com/address/0xb9015d7b35ce7c81dde38ef7136baa3b1044f313


## Polygon mainnet

The DieFiForwarder contract is located here:

https://polygonscan.com/address/0x85B8a43D660cB7af53403fC3093513f59129e2ED

The DieFiPolicy contract is located here:

https://polygonscan.com/address/0x81Ae8458B363Ba3fa83F373Ce5a8C2856a7043A2

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