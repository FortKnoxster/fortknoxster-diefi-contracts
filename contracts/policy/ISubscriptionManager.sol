
// SPDX-License-Identifier: MIT
pragma solidity ^0.8;

interface ISubscriptionManager {

    struct Policy {
        address payable sponsor;
        uint32 startTimestamp;
        uint32 endTimestamp;
        uint16 size;
        address owner;
    }

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

    function getPolicy(bytes16 _policyID) external view returns(Policy memory);

}