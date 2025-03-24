// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./FourMemeToken.sol";

// Mock ERC20 Token for testing purposes
contract MockERC20 is FourMemeToken {
    constructor(string memory name, string memory symbol, uint256 initialSupply) FourMemeToken(name, symbol, initialSupply, msg.sender) {}

    // Allows minting of tokens for testing
    function mintForTesting(address to, uint256 amount) external {
        _mint(to, amount);
    }

    // Allows burning of tokens for testing
    function burnForTesting(uint256 amount) external {
        _burn(msg.sender, amount);
    }
}
