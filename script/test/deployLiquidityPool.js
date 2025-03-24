// SPDX-License-Identifier: MIT
const { ethers } = require("hardhat");

async function main() {
    const [deployer] = await ethers.getSigners();
    console.log("Deploying contracts with the account:", deployer.address);

    // Deploy the LiquidityPool contract
    const LiquidityPool = await ethers.getContractFactory("LiquidityPool");
    const liquidityPool = await LiquidityPool.deploy();
    await liquidityPool.deployed();
    console.log("LiquidityPool deployed to:", liquidityPool.address);

    // Optionally, interact with the LiquidityPool contract after deployment
}

main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });
