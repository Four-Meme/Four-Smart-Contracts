// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface IFairLaunch {
    function startSale() external;
    function stopSale() external;
    function buyTokens() external payable;
}
