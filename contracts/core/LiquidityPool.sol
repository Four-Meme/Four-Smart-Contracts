// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./FourMemeToken.sol";

contract LiquidityPool {
    address public token;
    address public owner;
    uint256 public totalLiquidity;
    
    struct LiquidityProvider {
        uint256 amount;
        uint256 depositTime;
    }
    
    mapping(address => LiquidityProvider) public liquidity;
    
    event LiquidityAdded(address indexed provider, uint256 amount);
    event LiquidityRemoved(address indexed provider, uint256 amount);
    event FeeCollected(address indexed collector, uint256 amount);
    
    modifier onlyOwner() {
        require(msg.sender == owner, "Not contract owner");
        _;
    }
    
    constructor(address _token) {
        token = _token;
        owner = msg.sender;
    }
    
    function addLiquidity(uint256 amount) external {
        require(amount > 0, "Amount must be greater than zero");
        FourMemeToken(token).transferFrom(msg.sender, address(this), amount);
        
        liquidity[msg.sender].amount += amount;
        liquidity[msg.sender].depositTime = block.timestamp;
        totalLiquidity += amount;
        
        emit LiquidityAdded(msg.sender, amount);
    }
    
    function removeLiquidity(uint256 amount) external {
        require(liquidity[msg.sender].amount >= amount, "Insufficient liquidity");
        require(block.timestamp >= liquidity[msg.sender].depositTime + 1 days, "Liquidity locked for 24 hours");
        
        liquidity[msg.sender].amount -= amount;
        totalLiquidity -= amount;
        FourMemeToken(token).transfer(msg.sender, amount);
        
        emit LiquidityRemoved(msg.sender, amount);
    }
    
    function collectFees(uint256 amount) external onlyOwner {
        require(amount <= totalLiquidity / 10, "Cannot collect more than 10% of liquidity");
        totalLiquidity -= amount;
        FourMemeToken(token).transfer(owner, amount);
        
        emit FeeCollected(owner, amount);
    }
    
    function getLiquidity(address provider) external view returns (uint256) {
        return liquidity[provider].amount;
    }
}