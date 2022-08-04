
// SPDX-License-Identifier: MIT
pragma solidity ^0.8;

interface ISubscriptionManager {

    function getPolicyCost(
        uint16 _size,
        uint32 _startTimestamp,
        uint32 _endTimestamp
    ) external view returns (uint256);

    function createPolicy(
        bytes16 _policyId,
        address _policyOwner,
        uint16 _size,
        uint32 _startTimestamp,
        uint32 _endTimestamp
    ) external payable;

    function isPolicyActive(bytes16 _policyId) external view returns(bool);

}