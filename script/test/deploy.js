// SPDX-License-Identifier: MIT
const { ethers } = require("hardhat");

async function main() {
    const [deployer] = await ethers.getSigners();
    console.log("Deploying contracts with the account:", deployer.address);

    // Deploy the TokenFactory contract
    const TokenFactory = await ethers.getContractFactory("TokenFactory");
    const tokenFactory = await TokenFactory.deploy();
    await tokenFactory.deployed();
    console.log("TokenFactory deployed to:", tokenFactory.address);

    // Optionally, deploy additional contracts or interact with the deployed TokenFactory here
}

main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });
