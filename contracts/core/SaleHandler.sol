// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./FourMemeToken.sol";

contract SaleHandler {
    address public token;
    address public owner;
    uint256 public tokenPrice;
    bool public saleActive;
    
    event TokensPurchased(address indexed buyer, uint256 amount, uint256 cost);
    event SaleStateChanged(bool active);
    
    constructor(address _token, uint256 _tokenPrice) {
        token = _token;
        owner = msg.sender;
        tokenPrice = _tokenPrice;
    }
    
    modifier onlyOwner() {
        require(msg.sender == owner, "Not contract owner");
        _;
    }
    
    function startSale() external onlyOwner {
        saleActive = true;
        emit SaleStateChanged(true);
    }
    
    function stopSale() external onlyOwner {
        saleActive = false;
        emit SaleStateChanged(false);
    }
    
    function buyTokens() external payable {
        require(saleActive, "Token sale is not active");
        require(msg.value > 0, "Must send ETH to buy tokens");
        
        uint256 tokenAmount = (msg.value * 1e18) / tokenPrice;
        FourMemeToken(token).transfer(msg.sender, tokenAmount);
        
        emit TokensPurchased(msg.sender, tokenAmount, msg.value);
    }
}
