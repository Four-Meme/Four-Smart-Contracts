// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;


interface ITokenFactory {
    function createToken(string memory name, string memory symbol, uint256 totalSupply) external;
    function getTokenInfo(uint256 tokenId) external view returns (address, string memory, string memory, uint256, address);
}

