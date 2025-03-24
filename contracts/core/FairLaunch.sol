// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./FourMemeToken.sol";

contract FairLaunch {
    address public token;
    address public owner;
    uint256 public startTime;
    uint256 public endTime;
    uint256 public tokenPrice;
    mapping(address => uint256) public contributions;
    uint256 public totalContributed;
    
    event ContributionReceived(address indexed contributor, uint256 amount);
    event TokensClaimed(address indexed contributor, uint256 amount);
    
    constructor(address _token, uint256 _startTime, uint256 _endTime, uint256 _tokenPrice) {
        require(_endTime > _startTime, "Invalid time range");
        token = _token;
        owner = msg.sender;
        startTime = _startTime;
        endTime = _endTime;
        tokenPrice = _tokenPrice;
    }
    
    function contribute() external payable {
        require(block.timestamp >= startTime && block.timestamp <= endTime, "Fair launch not active");
        require(msg.value > 0, "Contribution must be greater than zero");
        
        contributions[msg.sender] += msg.value;
        totalContributed += msg.value;
        
        emit ContributionReceived(msg.sender, msg.value);
    }
    
    function claimTokens() external {
        require(block.timestamp > endTime, "Fair launch still ongoing");
        require(contributions[msg.sender] > 0, "No contribution found");
        
        uint256 tokenAmount = (contributions[msg.sender] * 1e18) / tokenPrice;
        contributions[msg.sender] = 0;
        FourMemeToken(token).transfer(msg.sender, tokenAmount);
        
        emit TokensClaimed(msg.sender, tokenAmount);
    }
}
