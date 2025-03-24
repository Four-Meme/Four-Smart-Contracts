// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./FourMemeToken.sol";

contract TokenFactory {
    address public owner;
    uint256 public tokenCount;
    
    struct TokenInfo {
        address tokenAddress;
        string name;
        string symbol;
        uint256 totalSupply;
        address creator;
    }
    
    mapping(uint256 => TokenInfo) public tokens;
    
    event TokenCreated(address indexed tokenAddress, string name, string symbol, uint256 totalSupply, address indexed owner);
    event TokenOwnershipTransferred(address indexed previousOwner, address indexed newOwner);
    
    modifier onlyOwner() {
        require(msg.sender == owner, "Not contract owner");
        _;
    }
    
    constructor() {
        owner = msg.sender;
    }
    
    function createToken(
        string memory name,
        string memory symbol,
        uint256 totalSupply
    ) external {
        FourMemeToken newToken = new FourMemeToken(name, symbol, totalSupply, msg.sender);
        
        tokens[tokenCount] = TokenInfo(address(newToken), name, symbol, totalSupply, msg.sender);
        tokenCount++;
        
        emit TokenCreated(address(newToken), name, symbol, totalSupply, msg.sender);
    }
    
    function getTokenInfo(uint256 tokenId) external view returns (TokenInfo memory) {
        require(tokenId < tokenCount, "Token does not exist");
        return tokens[tokenId];
    }
    
    function transferOwnership(address newOwner) external onlyOwner {
        require(newOwner != address(0), "Invalid new owner");
        
        address previousOwner = owner;
        owner = newOwner;
        
        emit TokenOwnershipTransferred(previousOwner, newOwner);
    }
}
