// SPDX-License-Identifier: MIT
pragma solidity ^0.8;

import "@openzeppelin/contracts/metatx/ERC2771Context.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "./ISubscriptionManager.sol";

/**
 * FortKnoxster DieFiPolicy using meta transaction via DieFiForwarder.
 */
contract DieFiPolicy is ERC2771Context, ReentrancyGuard {

    constructor(address _trustedForwarder, address _subscriptionManager) ERC2771Context(_trustedForwarder) {
        _setSubscriptionManager(_subscriptionManager);
    }

    event SubscriptionManagerUpdated(address oldSubscriptionManager, address newSubscriptionManager);

    event DieFiPolicyCreated(
        bytes16 indexed policyId,
        address indexed owner,
        uint16 size,
        uint32 startTimestamp,
        uint32 endTimestamp,
        uint256 cost
    );

    address public subscriptionManager;

    function _setSubscriptionManager(address newSubscriptionManager) internal {
        address oldSubscriptionManager = subscriptionManager;
        subscriptionManager = newSubscriptionManager;
        emit SubscriptionManagerUpdated(oldSubscriptionManager, newSubscriptionManager);
    }

    function _msgSender() internal view override (ERC2771Context) returns (address sender) {
        return super._msgSender();
    }

    function _msgData() internal view override (ERC2771Context) returns (bytes calldata) {
        return super._msgData();
    }

    function createPolicy(
        bytes16 _policyId,
        address _policyOwner,
        uint16 _size,
        uint32 _startTimestamp,
        uint32 _endTimestamp
    )
        external 
        payable
        nonReentrant
    {
        require(
            _startTimestamp < _endTimestamp && 
            block.timestamp < _endTimestamp && 
            _startTimestamp > block.timestamp,
            "Invalid timestamps"
        );
        
        // Policy cost is validated in remote SubscriptionManager
        ISubscriptionManager(subscriptionManager).createPolicy{value: msg.value }(
            _policyId,
            _policyOwner,
            _size,
            _startTimestamp,
            _endTimestamp
        );

        emit DieFiPolicyCreated(
            _policyId,
            _policyOwner,
            _size,
            _startTimestamp,
            _endTimestamp,
            msg.value
        );
    }

    function getPolicyCost(
        uint16 _size,
        uint32 _startTimestamp,
        uint32 _endTimestamp
    ) public view returns (uint256) {
        return ISubscriptionManager(subscriptionManager).getPolicyCost(_size, _startTimestamp, _endTimestamp);
    }

    function isPolicyActive(bytes16 _policyId) public view returns(bool) {
        return ISubscriptionManager(subscriptionManager).isPolicyActive(_policyId);
    }

    function getPolicy(bytes16 _policyId) public view returns(ISubscriptionManager.Policy memory){
        return ISubscriptionManager(subscriptionManager).getPolicy(_policyId);
    }
}