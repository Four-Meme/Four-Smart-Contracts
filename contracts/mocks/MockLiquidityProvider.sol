// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "../contracts/core/LiquidityPool.sol";

// Mock Liquidity Provider for testing purposes
contract MockLiquidityProvider {
    ILiquidityPool public liquidityPool;
    address public liquidityProvider;

    constructor(address _liquidityPool) {
        liquidityPool = ILiquidityPool(_liquidityPool);
        liquidityProvider = msg.sender;
    }

    // Function to add liquidity to the pool for testing
    function addLiquidityForTesting(uint256 amount) external {
        // Ensure only the liquidity provider can add liquidity
        require(msg.sender == liquidityProvider, "Only liquidity provider can add liquidity");
        liquidityPool.addLiquidity(amount);
    }

    // Function to remove liquidity from the pool for testing
    function removeLiquidityForTesting(uint256 amount) external {
        // Ensure only the liquidity provider can remove liquidity
        require(msg.sender == liquidityProvider, "Only liquidity provider can remove liquidity");
        liquidityPool.removeLiquidity(amount);
    }

    // Function to check the liquidity balance of the provider
    function checkLiquidity() external view returns (uint256) {
        return liquidityPool.getLiquidity(liquidityProvider);
    }
}
