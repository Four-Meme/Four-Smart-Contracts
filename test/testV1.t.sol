// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import {Bag, Token} from "../src/v1/Bag.sol";

contract uniV3GasTest is Test {
    Token public bot_gas;
    Bag public bag;	
    string public name = "FOURMEME TEST";
    string public symbol = "FTEST";
    uint256 public totalSupply;
    address public owner;
    address public tokenAddress;
	
	// Launch test token address: ###

	// The address of the token contract will be set after the contract is deployed
	// and the transaction is mined. The contract address can be accessed once the
	// deployment process is complete, and it will be used to interact with the token.
    function setUp() public {
        vm.createSelectFork("base");
        deal(address(this), 100e18);
        emit log_named_address("this", address(this));
        emit log_named_address("msg.sender", msg.sender);
        bag = new Bag();
        emit log_string("deploy ..");
        bot_gas =
            Token(payable(bag.createBumpAndBuy{value: 1e18}("name", "symbol", "intro", "icon", "twi", "tel", "web")));

        emit log_named_decimal_uint("balance", bot_gas.balanceOf(address(this)), 18);
        emit log_named_decimal_uint("mCap", bot_gas.mCap(), 18);
    }

    function testBuy() public {
        {
            uint256 prev_balance = address(bot_gas).balance;
            emit log_string("buy for 1e4 token ...");
            uint256 bnbResult = bot_gas.calPresaleSwapbnbForExactToken(1e4 * 1e18);
            emit log_named_decimal_uint("bnbResult", bnbResult, 18);

            bot_gas.presaleSwapbnbForToken{value: bnbResult}(address(this));

            emit log_named_decimal_uint("token contract balance", address(bot_gas).balance - prev_balance, 18);
            emit log_named_decimal_uint("get token", bot_gas.balanceOf(address(this)), 18);
        }

        {
            uint256 prev_balance = address(bot_gas).balance;
            emit log_string("sell for 0.01 bnb ...");
            uint256 tokenResult = bot_gas.calPresaleSwapTokenForExactbnb(1e16);
            emit log_named_decimal_uint("tokenResult", tokenResult, 18);

            bot_gas.presaleSwapTokenForbnb(address(this), tokenResult);

            emit log_named_decimal_uint("token contract balance", prev_balance - address(bot_gas).balance, 18);
            emit log_named_decimal_uint("get token", bot_gas.balanceOf(address(this)), 18);
        }

        // -------------------------------

        {
            emit log_string("buy with 1 bnb ...");
            uint256 tokenResult = bot_gas.calPresaleSwapbnbForToken(1e18);
            bot_gas.presaleSwapbnbForToken{value: 1e18}(address(this));

            emit log_named_decimal_uint("tokenResult", tokenResult, 18);
            emit log_named_decimal_uint("token contract balance", address(bot_gas).balance, 18);
            emit log_named_decimal_uint("get token", bot_gas.balanceOf(address(this)), 18);
        }

        {
            emit log_string("buy with 0.1 bnb ...");
            uint256 tokenResult = bot_gas.calPresaleSwapbnbForToken(1e17);
            bot_gas.presaleSwapbnbForToken{value: 1e17}(address(this));

            emit log_named_decimal_uint("tokenResult", tokenResult, 18);
            emit log_named_decimal_uint("token contract balance", address(bot_gas).balance, 18);
            emit log_named_decimal_uint("get token", bot_gas.balanceOf(address(this)), 18);
            emit log_named_decimal_uint("mCap", bot_gas.mCap(), 18);
        }

        {
            emit log_string("buy with 0.1 bnb ...");
            uint256 tokenResult = bot_gas.calPresaleSwapbnbForToken(1e17);
            bot_gas.presaleSwapbnbForToken{value: 1e17}(address(this));

            emit log_named_decimal_uint("tokenResult", tokenResult, 18);
            emit log_named_decimal_uint("token contract balance", address(bot_gas).balance, 18);
            emit log_named_decimal_uint("get token", bot_gas.balanceOf(address(this)), 18);
            emit log_named_decimal_uint("mCap", bot_gas.mCap(), 18);
        }

        {
            emit log_string("buy with 0.1 bnb ...");
            uint256 tokenResult = bot_gas.calPresaleSwapbnbForToken(1e17);
            bot_gas.presaleSwapbnbForToken{value: 1e17}(address(this));

            emit log_named_decimal_uint("tokenResult", tokenResult, 18);
            emit log_named_decimal_uint("token contract balance", address(bot_gas).balance, 18);
            emit log_named_decimal_uint("get token", bot_gas.balanceOf(address(this)), 18);
            emit log_named_decimal_uint("mCap", bot_gas.mCap(), 18);
        }

        {
            emit log_string("buy with 0.1 bnb ...");
            uint256 tokenResult = bot_gas.calPresaleSwapbnbForToken(1e17);
            bot_gas.presaleSwapbnbForToken{value: 1e17}(address(this));

            emit log_named_decimal_uint("tokenResult", tokenResult, 18);
            emit log_named_decimal_uint("token contract balance", address(bot_gas).balance, 18);
            emit log_named_decimal_uint("get token", bot_gas.balanceOf(address(this)), 18);
            emit log_named_decimal_uint("mCap", bot_gas.mCap(), 18);
        }

        {
            emit log_string("buy with 0.1 bnb ...");
            uint256 tokenResult = bot_gas.calPresaleSwapbnbForToken(1e17);
            bot_gas.presaleSwapbnbForToken{value: 1e17}(address(this));

            emit log_named_decimal_uint("tokenResult", tokenResult, 18);
            emit log_named_decimal_uint("token contract balance", address(bot_gas).balance, 18);
            emit log_named_decimal_uint("get token", bot_gas.balanceOf(address(this)), 18);
            emit log_named_decimal_uint("mCap", bot_gas.mCap(), 18);
        }

        {
            emit log_string("buy with 0.1 bnb ...");
            uint256 tokenResult = bot_gas.calPresaleSwapbnbForToken(1e17);
            bot_gas.presaleSwapbnbForToken{value: 1e17}(address(this));

            emit log_named_decimal_uint("tokenResult", tokenResult, 18);
            emit log_named_decimal_uint("token contract balance", address(bot_gas).balance, 18);
            emit log_named_decimal_uint("get token", bot_gas.balanceOf(address(this)), 18);
            emit log_named_decimal_uint("mCap", bot_gas.mCap(), 18);
        }

        {
            emit log_string("buy with 0.1 bnb ...");
            uint256 tokenResult = bot_gas.calPresaleSwapbnbForToken(1e17);
            bot_gas.presaleSwapbnbForToken{value: 1e17}(address(this));

            emit log_named_decimal_uint("tokenResult", tokenResult, 18);
            emit log_named_decimal_uint("token contract balance", address(bot_gas).balance, 18);
            emit log_named_decimal_uint("get token", bot_gas.balanceOf(address(this)), 18);
            emit log_named_decimal_uint("mCap", bot_gas.mCap(), 18);
        }

        {
            emit log_string("buy with 2.6 bnb ...");
            uint256 tokenResult = bot_gas.calPresaleSwapbnbForToken(26e17);
            bot_gas.presaleSwapbnbForToken{value: 26e17}(address(this));

            emit log_named_decimal_uint("tokenResult", tokenResult, 18);
            emit log_named_decimal_uint("token contract balance", address(bot_gas).balance, 18);
            emit log_named_decimal_uint("get token", bot_gas.balanceOf(address(this)), 18);
            emit log_named_decimal_uint("mCap", bot_gas.mCap(), 18);
        }

        {
            emit log_string("sell ...");
            uint256 bnbResult = bot_gas.calPresaleSwapTokenForbnb(bot_gas.balanceOf(address(this)));
            bot_gas.presaleSwapTokenForbnb(address(this), bot_gas.balanceOf(address(this)));

            emit log_named_decimal_uint("bnbResult", bnbResult, 18);
            emit log_named_decimal_uint("token contract balance", address(bot_gas).balance, 18);
            emit log_named_decimal_uint("get token", bot_gas.balanceOf(address(this)), 18);
            emit log_named_decimal_uint("mCap", bot_gas.mCap(), 18);

            emit log_string("buy with 5.4 bnb ...");
            uint256 tokenResult = bot_gas.calPresaleSwapbnbForToken(54e17);
            bot_gas.presaleSwapbnbForToken{value: 54e17}(address(this));

            emit log_named_decimal_uint("tokenResult", tokenResult, 18);
            emit log_named_decimal_uint("token contract balance", address(bot_gas).balance, 18);
            emit log_named_decimal_uint("get token", bot_gas.balanceOf(address(this)), 18);
            emit log_named_decimal_uint("mCap", bot_gas.mCap(), 18);
        }
    }

    receive() external payable {}
}
