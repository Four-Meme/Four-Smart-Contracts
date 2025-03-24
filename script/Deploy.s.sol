// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.21;

import "forge-std/Script.sol";
import "../src/v1/Bag.sol";

contract BotScript is Script {
    function setUp() public {
        vm.createSelectFork("base");
    }

    function run() public {
        uint256 deployerPrivateKey = vm.envUint("MAIN_KEY");

        vm.startBroadcast(deployerPrivateKey);

        Bag bag = new Bag();

        vm.stopBroadcast();
    }
}
