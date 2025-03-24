// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./FourMemeToken.sol";

contract Vesting {
    address public token;
    address public owner;
    uint256 public totalVested;
    uint256 public unlockTime;
    mapping(address => uint256) public vestedAmounts;
    mapping(address => uint256) public cliffTime;
    
    event TokensVested(address indexed recipient, uint256 amount, uint256 cliff);
    event TokensClaimed(address indexed recipient, uint256 amount);
    event VestingRevoked(address indexed recipient, uint256 amount);
    
    constructor(address _token, uint256 _unlockTime) {
        token = _token;
        owner = msg.sender;
        unlockTime = _unlockTime;
    }
    
    modifier onlyOwner() {
        require(msg.sender == owner, "Not contract owner");
        _;
    }
    
    function vestTokens(address recipient, uint256 amount, uint256 cliff) external onlyOwner {
        require(cliff <= unlockTime, "Cliff cannot be after unlock time");
        vestedAmounts[recipient] += amount;
        totalVested += amount;
        cliffTime[recipient] = cliff;
        emit TokensVested(recipient, amount, cliff);
    }
    
    function claimTokens() external {
        require(block.timestamp >= unlockTime, "Tokens are still locked");
        require(vestedAmounts[msg.sender] > 0, "No vested tokens");
        require(block.timestamp >= cliffTime[msg.sender], "Cliff period not reached");
        
        uint256 amount = vestedAmounts[msg.sender];
        vestedAmounts[msg.sender] = 0;
        FourMemeToken(token).transfer(msg.sender, amount);
        
        emit TokensClaimed(msg.sender, amount);
    }
    
    function revokeVesting(address recipient) external onlyOwner {
        require(vestedAmounts[recipient] > 0, "No vested tokens to revoke");
        
        uint256 amount = vestedAmounts[recipient];
        vestedAmounts[recipient] = 0;
        totalVested -= amount;
        
        emit VestingRevoked(recipient, amount);
    }
}
