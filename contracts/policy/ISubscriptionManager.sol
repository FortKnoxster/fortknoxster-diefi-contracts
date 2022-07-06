
// SPDX-License-Identifier: MIT
pragma solidity ^0.8;

interface ISubscriptionManager {

    function createPolicy(
        bytes16 _policyId,
        address _policyOwner,
        uint16 _size,
        uint32 _startTimestamp,
        uint32 _endTimestamp
    ) external payable;

}