// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.21;

import "forge-std/Script.sol";
import "../src/v1/Bag.sol";

contract BotScript is Script {
    function setUp() public {
        vm.createSelectFork("base_sepolia");
    }

    function run() public {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");

        vm.startBroadcast(deployerPrivateKey);

        Bag bag = new Bag();
        Token bot_gas =
            Token(payable(bag.createBumpAndBuy{value: 1e14}("name", "symbol", "intro", "icon", "twi", "tel", "web")));

        vm.stopBroadcast();
    }
}
