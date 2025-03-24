// SPDX-License-Identifier: MIT

pragma solidity 0.8.21;

import {Token} from "./Token.sol";

abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }
}

interface IERC20 {
    function totalSupply() external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function transfer(address recipient, uint256 amount) external returns (bool);
    function allowance(address owner, address spender) external view returns (uint256);
    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
}

library SafeMath {
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");
        return c;
    }

    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        return sub(a, b, "SafeMath: subtraction overflow");
    }

    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b <= a, errorMessage);
        uint256 c = a - b;
        return c;
    }

    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        if (a == 0) {
            return 0;
        }
        uint256 c = a * b;
        require(c / a == b, "SafeMath: multiplication overflow");
        return c;
    }

    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        return div(a, b, "SafeMath: division by zero");
    }

    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b > 0, errorMessage);
        uint256 c = a / b;
        return c;
    }
}

interface IUniswapV2Factory {
    function createPair(address tokenA, address tokenB) external returns (address pair);
    function getPair(address tokenA, address tokenB) external view returns (address pair);
}

interface IUniswapV2Router02 {
    function swapExactTokensForETHSupportingFeeOnTransferTokens(
        uint256 amountIn,
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external;
    function factory() external pure returns (address);
    function WETH() external pure returns (address);
    function addLiquidityETH(
        address token,
        uint256 amountTokenDesired,
        uint256 amountTokenMin,
        uint256 amountETHMin,
        address to,
        uint256 deadline
    ) external payable returns (uint256 amountToken, uint256 amountETH, uint256 liquidity);
    function removeLiquidityETH(
        address token,
        uint256 liquidity,
        uint256 amountTokenMin,
        uint256 amountETHMin,
        address to,
        uint256 deadline
    ) external returns (uint256 amountToken, uint256 amountETH);
}

contract TimeComparison {
    uint256 private constant SECONDS_PER_DAY = 86400;

    function isDifferentDay(uint256 timestamp) internal view returns (bool) {
        uint256 today = block.timestamp / SECONDS_PER_DAY;
        uint256 otherDay = timestamp / SECONDS_PER_DAY;

        return today != otherDay;
    }
}

contract Bag is TimeComparison {
    event OpenBumpPresale(address indexed deployer, address indexed token);

    IUniswapV2Router02 private constant uniswapV2Router = IUniswapV2Router02(0x4752ba5DBc23f44D87826276BF6Fd6b1C372aD24);

    mapping(address => address) public maker;

    uint256 public totalMaker;

    constructor() {
        totalMaker = 0;
    }

    function createBump(
        string memory _name,
        string memory _symbol,
        string memory _introduction,
        string memory _iconAddress,
        string memory _twitterAddress,
        string memory _telegramAddress,
        string memory _websiteAddress
    ) public returns (address) {
        Token token =
            new Token(_name, _symbol, _introduction, _iconAddress, _twitterAddress, _telegramAddress, _websiteAddress);

        maker[address(token)] = msg.sender;
        totalMaker += 1;

        emit OpenBumpPresale(msg.sender, address(token));

        return address(token);
    }

    function createBumpAndBuy(
        string memory _name,
        string memory _symbol,
        string memory _introduction,
        string memory _iconAddress,
        string memory _twitterAddress,
        string memory _telegramAddress,
        string memory _websiteAddress
    ) external payable returns (address) {
        address token =
            createBump(_name, _symbol, _introduction, _iconAddress, _twitterAddress, _telegramAddress, _websiteAddress);

        Token(payable(token)).presaleSwapETHForToken{value: msg.value}(msg.sender);

        return token;
    }
}
