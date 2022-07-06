// SPDX-License-Identifier: MIT
pragma solidity ^0.8;

import "@openzeppelin/contracts/metatx/ERC2771Context.sol"; 
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts-upgradeable/access/AccessControlUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "./ISubscriptionManager.sol";

contract DieFiPolicy is ERC2771Context, 
                        Ownable, 
                        Initializable, 
                        AccessControlUpgradeable {

    constructor(address _trustedForwarder) ERC2771Context(_trustedForwarder) {}

    event SubscriptionManagerUpdated(address oldSubscriptionManager, address newSubscriptionManager);
    event SetTrustedForwarder(address newTrustedForwarder);

    address public subscriptionManager;
    function initialize(address _subscriptionManager) public initializer {
        _setSubscriptionManager(_subscriptionManager);
        _setupRole(DEFAULT_ADMIN_ROLE, msg.sender);
        //_setTrustedForwarder(_trustedForwarder);
    }

    function _setSubscriptionManager(address newSubscriptionManager) internal {
        address oldSubscriptionManager = subscriptionManager;
        subscriptionManager = newSubscriptionManager;
        emit SubscriptionManagerUpdated(oldSubscriptionManager, newSubscriptionManager);
    }

    function setSubscriptionManager(address _subscriptionManager) onlyRole(DEFAULT_ADMIN_ROLE) external {
        _setSubscriptionManager(_subscriptionManager);
    }

    function _msgSender() internal view virtual override (ERC2771Context, ContextUpgradeable, Context) returns (address sender) {
        return super._msgSender();
    }

    function _msgData() internal view virtual override (ERC2771Context, ContextUpgradeable, Context) returns (bytes calldata) {
        return super._msgData();
    }
    /*
    function _setTrustedForwarder(address newTrustedForwarder) internal {
        trustedForwarder = newTrustedForwarder;
        emit SetTrustedForwarder(newTrustedForwarder);
    }

    function setTrustedForwarder(address _trustedForwarder) onlyRole(DEFAULT_ADMIN_ROLE) external {
        _setTrustedForwarder(_trustedForwarder);
    }
    */

    function createPolicy(
        bytes16 _policyId,
        address _policyOwner,
        uint16 _size,
        uint32 _startTimestamp,
        uint32 _endTimestamp
    )
        external payable
    {
        require(
            _startTimestamp < _endTimestamp && block.timestamp < _endTimestamp,
            "Invalid timestamps"
        );
        require(
            msg.value == getPolicyCost(_size, _startTimestamp, _endTimestamp),
            "Invalid policy cost"
        );

        _createPolicy(_policyId, _policyOwner, _size, _startTimestamp, _endTimestamp);

        ISubscriptionManager(subscriptionManager).createPolicy(
            _policyId,
            _policyOwner,
            _size,
            _startTimestamp,
            _endTimestamp
        );
    }
}