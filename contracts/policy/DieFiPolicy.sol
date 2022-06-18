// SPDX-License-Identifier: MIT
pragma solidity ^0.8;

import "@openzeppelin/contracts/metatx/ERC2771Context.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin-upgradeable/contracts/access/AccessControlUpgradeable.sol";
import "@openzeppelin-upgradeable/contracts/proxy/utils/Initializable.sol";

contract DieFiPolicy is ERC2771Context, Ownable, Initializable, AccessControlUpgradeable {

    event SubscriptionManagerUpdated(address oldSubscriptionManager, uint256 newSubscriptionManager);

    address public subscriptionManager;
    function initialize(address _subscriptionManager) public initializer {
        _setSubscriptionManager(_subscriptionManager);
        _setupRole(DEFAULT_ADMIN_ROLE, msg.sender);
    }

    function _setSubscriptionManager(address newSubscriptionManager) internal {
        address oldSubscriptionManager = subscriptionManager;
        subscriptionManager = newSubscriptionManager;
        emit SubscriptionManagerUpdated(oldSubscriptionManager, newSubscriptionManager);
    }

    function setSubscriptionManager(address _subscriptionManager) onlyRole(DEFAULT_ADMIN_ROLE) external {
        _setSubscriptionManager(_subscriptionManager);
    }
}