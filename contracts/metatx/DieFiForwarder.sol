// SPDX-License-Identifier: MIT
pragma solidity ^0.8;

import "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";
import "@openzeppelin/contracts/utils/cryptography/draft-EIP712.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";
import "@openzeppelin/contracts/security/Pausable.sol";

/**
 *
 * Based on OpenZeppelin MinimalForwarder adding pause functionality and access control
 * with relayer whitelisting. 
 * https://github.com/OpenZeppelin/openzeppelin-contracts/blob/ec825d8999538f110e572605dc56ef7bf44cc574/contracts/metatx/MinimalForwarder.sol
 */
contract DieFiForwarder is EIP712, AccessControl, Pausable {
     using ECDSA for bytes32;

    struct ForwardRequest {
        address from;
        address to;
        uint256 value;
        uint256 gas;
        uint256 nonce;
        bytes data;
    }

    bytes32 private constant _TYPEHASH =
        keccak256("ForwardRequest(address from,address to,uint256 value,uint256 gas,uint256 nonce,bytes data)");

    bytes32 public constant RELAY_ROLE = keccak256("Power to relay meta transactions");

    mapping(address => uint256) private _nonces;

    event MetaTransactionExecuted(address indexed from, address indexed to, bytes indexed data);

    constructor(address _trustedRelayer) EIP712("DieFiForwarder", "0.0.1") {
        _setupRole(DEFAULT_ADMIN_ROLE, msg.sender);
        _setupRole(RELAY_ROLE, _trustedRelayer);
    }

        function getNonce(address from) public view returns (uint256) {
        return _nonces[from];
    }

    function verify(ForwardRequest calldata req, bytes calldata signature) public view returns (bool) {
        address signer = _hashTypedDataV4(
            keccak256(abi.encode(_TYPEHASH, req.from, req.to, req.value, req.gas, req.nonce, keccak256(req.data)))
        ).recover(signature);
        return _nonces[req.from] == req.nonce && signer == req.from;
    }

    function execute(ForwardRequest calldata req, bytes calldata signature)
        public
        payable
        whenNotPaused()
        onlyRole(RELAY_ROLE)
        returns (bool, bytes memory)
    {
        require(verify(req, signature), "DieFiForwarder: signature does not match request");
        _nonces[req.from] = req.nonce + 1;

        (bool success, bytes memory returndata) = req.to.call{gas: req.gas, value: req.value}(
            abi.encodePacked(req.data, req.from)
        );

        // Validate that the relayer has sent enough gas for the call.
        // See https://ronan.eth.link/blog/ethereum-gas-dangers/
        if (gasleft() <= req.gas / 63) {
            // We explicitly trigger invalid opcode to consume all gas and bubble-up the effects, since
            // neither revert or assert consume all gas since Solidity 0.8.0
            // https://docs.soliditylang.org/en/v0.8.0/control-structures.html#panic-via-assert-and-error-via-require
            /// @solidity memory-safe-assembly
            assembly {
                invalid()
            }
        }

        emit MetaTransactionExecuted(req.from, req.to, req.data);

        return (success, returndata);
    }

    /**
     * Pause meta transaction exection,
     */
    function pause() onlyRole(DEFAULT_ADMIN_ROLE) public virtual whenNotPaused {
        super._pause();
    }

    /**
     * Unpause meta transaction exection,
     */
    function unpause() onlyRole(DEFAULT_ADMIN_ROLE) public virtual whenPaused {
        super._unpause();
    }

}