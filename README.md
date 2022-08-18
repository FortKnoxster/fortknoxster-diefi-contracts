# Fortknoxster Diefi Contracts

FortKnoxster DieFi smart contract on Polygon for managing a decentralized Dead Man's Switch using gasless meta transactions.

To create a policy for the DieFi Dead Man's Switch, the client browser/user prepares and signs an [EIP-2771](https://eips.ethereum.org/EIPS/eip-2771) meta transaction using [EIP-712](https://eips.ethereum.org/EIPS/eip-712) typed structured data hashing and signing, and sends it to a relayer/payer. The relayer verifies the signed transaction and sends it to the DieFiForwarder who verifies the relayer is trusted and also verifies the signed transaction. The DieFiForwarder executes the transaction sending it to the DieFiPolicy which in turn sends it to Threshold's SubscriptionManager.

The final policy created, consists of time-based conditions according to the Dead Man's Switch timer settings and the size of the threshold shares on the Threshold decentralized network.


## Mumbai testnet

The DieFiForwarder contract is loated here:

https://mumbai.polygonscan.com/address/0xd5f9268e1d55736d51cfb38f27bb6cd325bd6fe0

The DieFiPolicy contract is located here:

https://mumbai.polygonscan.com/address/0x2698af21d7e2bf325a758382591d6df9f8dc3692

The NuCypher/Threshold SubscriptionManager is loated here:

https://mumbai.polygonscan.com/address/0xb9015d7b35ce7c81dde38ef7136baa3b1044f313


## Polygon mainnet
Pending mainnet deployment
