// SPDX-License-Identifier: MIT
const { ethers } = require("hardhat");

async function main() {
    const [deployer] = await ethers.getSigners();
    console.log("Deploying contracts with the account:", deployer.address);

    // Deploy the FairLaunch contract
    const FairLaunch = await ethers.getContractFactory("FairLaunch");
    const fairLaunch = await FairLaunch.deploy();
    await fairLaunch.deployed();
    console.log("FairLaunch deployed to:", fairLaunch.address);

    // Optionally, you can interact with the FairLaunch contract here
}

main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });
{\rtf1}