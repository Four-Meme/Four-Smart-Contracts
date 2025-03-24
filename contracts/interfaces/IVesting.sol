// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;


interface IVesting {
    function vestTokens(address recipient, uint256 amount, uint256 cliff) external;
    function claimTokens() external;
    function revokeVesting(address recipient) external;
}
