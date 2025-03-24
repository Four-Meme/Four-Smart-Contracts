// SPDX-License-Identifier: MIT

pragma solidity 0.8.21;

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

contract Ownable is Context {
    address private _owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    constructor() {
        address msgSender = _msgSender();
        _owner = msgSender;
        emit OwnershipTransferred(address(0), msgSender);
    }

    function owner() public view returns (address) {
        return _owner;
    }

    modifier onlyOwner() {
        require(_owner == _msgSender(), "Ownable: caller is not the owner");
        _;
    }

    function renounceOwnership() public virtual onlyOwner {
        emit OwnershipTransferred(_owner, address(0));
        _owner = address(0);
    }
}

interface IUniswapV2Pair {
    function getReserves() external view returns (uint112 _reserve0, uint112 _reserve1, uint32 _blockTimestampLast);
}

interface IUniswapV2Factory {
    function createPair(address tokenA, address tokenB) external returns (address pair);
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
}

contract Token is Context, IERC20 {
    using SafeMath for uint256;

    uint8 public constant version = 1;

    mapping(address => uint256) private _balances;
    mapping(address => mapping(address => uint256)) private _allowances;

    address payable public _devWallet = payable(0xA2CB4a8E7c22045a1B62d2101d7cA8c58e8C4078);

    uint8 private constant _decimals = 18;
    uint112 private constant _priceReciprocalLimit = 7232226802;

    string public name;
    string public symbol;

    string public introduction;
    string public iconAddress;
    string public twitterAddress;
    string public telegramAddress;
    string public websiteAddress;

    // For the virtual pool
    uint256 private constant k = 20912493692096136 * (10 ** _decimals) * (10 ** _decimals) / 10 ** 7;
    uint256 private constant initialETH = 193058 * (10 ** (_decimals - 5));
    uint256 private constant initialToken = 8322336769759 * (10 ** (_decimals - 5));

    uint256 private constant _mcap = 53 * 10 ** (_decimals - 1);

    uint256 private constant _openTradingFee = 15 * 10 ** (_decimals - 2);
    uint256 private constant _presaleFeeRatio = 990;

    IUniswapV2Router02 private constant uniswapV2Router = IUniswapV2Router02(0x4752ba5DBc23f44D87826276BF6Fd6b1C372aD24);

    uint256 private _tTotal;

    address private uniswapV2Pair;
    bool public tradingOpen = false;
    bool public presaleOpen = true;
    bool private poolFail = false;

    address public immutable bag;

    event BumpPresale(
        address indexed player, address indexed to, bool indexed buy, uint256 ethAmount, uint256 tokenAmount
    );
    event OpenBumpTrading(address indexed token);

    constructor(
        string memory _name,
        string memory _symbol,
        string memory _introduction,
        string memory _iconAddress,
        string memory _twitterAddress,
        string memory _telegramAddress,
        string memory _websiteAddress
    ) {
        name = _name;
        symbol = _symbol;

        introduction = _introduction;
        iconAddress = _iconAddress;
        twitterAddress = _twitterAddress;
        telegramAddress = _telegramAddress;
        websiteAddress = _websiteAddress;

        _tTotal = 1000000000 * 10 ** _decimals;

        bag = _msgSender();

        _balances[address(this)] = _tTotal;
        emit Transfer(address(0), address(this), _tTotal);
    }

    function decimals() public pure returns (uint8) {
        return _decimals;
    }

    function totalSupply() public view override returns (uint256) {
        return _tTotal;
    }

    function balanceOf(address account) public view override returns (uint256) {
        return _balances[account];
    }

    function transfer(address recipient, uint256 amount) public override returns (bool) {
        _transfer(_msgSender(), recipient, amount);
        return true;
    }

    function allowance(address owner, address spender) public view override returns (uint256) {
        return _allowances[owner][spender];
    }

    function approve(address spender, uint256 amount) public override returns (bool) {
        _approve(_msgSender(), spender, amount);
        return true;
    }

    function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
        _transfer(sender, recipient, amount);
        _approve(
            sender,
            _msgSender(),
            _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance")
        );
        return true;
    }

    function _approve(address owner, address spender, uint256 amount) private {
        require(owner != address(0), "ERC20: approve from the zero address");
        require(spender != address(0), "ERC20: approve to the zero address");
        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }

    function _transfer(address from, address to, uint256 amount) private {
        require(from != address(0), "ERC20: transfer from the zero address");
        require(amount > 0, "Transfer amount must be greater than zero");

        _balances[from] = _balances[from].sub(amount);
        _balances[to] = _balances[to].add(amount);
        emit Transfer(from, to, amount);

        if (to == address(0)) {
            _tTotal = _tTotal - amount;
        }
    }

    function min(uint256 a, uint256 b) private pure returns (uint256) {
        return (a > b) ? b : a;
    }

    function openTrading() private {
        require(!tradingOpen, "trading is already open");

        _approve(address(this), address(uniswapV2Router), _tTotal);

        uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());
        // LP token receiver modified to owner instead of 0xdead
        uniswapV2Router.addLiquidityETH{value: address(this).balance}(
            address(this), balanceOf(address(this)), 0, 0, address(0), block.timestamp
        );

        IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint256).max);

        tradingOpen = true;
        presaleOpen = false;

        emit OpenBumpTrading(address(this));
    }

    function mCap() external view returns (uint256) {
        if (!tradingOpen) {
            uint256 price = (address(this).balance + initialETH) * 10 ** 18 / (_balances[address(this)] + initialToken);
            return _tTotal / 10 ** 18 * price;
        } else {
            (uint112 r1, uint112 r2,) = IUniswapV2Pair(uniswapV2Pair).getReserves();
            (uint256 ethReserve, uint256 tokenReserve) =
                address(this) > uniswapV2Router.WETH() ? (uint256(r1), uint256(r2)) : (uint256(r2), uint256(r1));
            uint256 price = ethReserve * 10 ** 18 / tokenReserve;
            return _tTotal / 10 ** 18 * price;
        }
    }

    /**
     * Presale function section
     */

    // helper functions
    function _presaleTokenCalculation() private view returns (uint256) {
        uint256 tokenAmount = _balances[address(this)] + initialToken - (k / (address(this).balance + initialETH));
        return tokenAmount;
    }

    function _presaleETHCalculation(uint256 tokenAmount) private view returns (uint256) {
        uint256 ethAmount =
            address(this).balance + initialETH - (k / (_balances[address(this)] + initialToken + tokenAmount));
        return ethAmount;
    }

    // Swap ETH to token in presale section
    function presaleSwapETHForToken(address to) public payable {
        require(presaleOpen, "Presale is not open");
        require(msg.value > 0, "Invalid amount");

        uint256 ethAmount = (msg.value).mul(_presaleFeeRatio).div(1000);
        uint256 swapFee = (msg.value) - ethAmount;
        _devWallet.transfer(swapFee);

        uint256 tokenAmount = _presaleTokenCalculation();

        // Ensure contract has enough balance to transfer tokens
        require(tokenAmount <= _balances[address(this)], "Insufficient balance in contract");

        _transfer(address(this), to, tokenAmount);

        emit BumpPresale(_msgSender(), to, true, msg.value, tokenAmount);

        if (address(this).balance > _mcap) {
            _devWallet.transfer(_openTradingFee);
            openTrading();
        }
    }

    // Swap token to ETH in presale section
    function presaleSwapTokenForETH(address to, uint256 tokenAmount) external {
        require(presaleOpen, "Presale is not open");
        require(tokenAmount > 0, "Invalid amount");

        // Ensure contract has enough balance to transfer ETH
        uint256 ethAmount = _presaleETHCalculation(tokenAmount);

        require(address(this).balance >= ethAmount, "Insufficient ETH balance in contract");
        uint256 ethForPlayer = ethAmount.mul(_presaleFeeRatio).div(1000);
        uint256 swapFee = ethAmount - ethForPlayer;
        _devWallet.transfer(swapFee);

        _transfer(_msgSender(), address(this), tokenAmount);

        // Transfer ETH to player
        payable(to).transfer(ethForPlayer);

        emit BumpPresale(_msgSender(), to, false, ethForPlayer, tokenAmount);
    }

    receive() external payable {
        presaleSwapETHForToken(msg.sender);
    }

    // view
    function calPresaleSwapETHForToken(uint256 ethTotal) external view returns (uint256) {
        uint256 ethAmount = (ethTotal).mul(_presaleFeeRatio).div(1000);
        uint256 tokenAmount =
            _balances[address(this)] + initialToken - (k / (ethAmount + address(this).balance + initialETH));

        require(tokenAmount <= _balances[address(this)], "Insufficient token balance in contract");

        return tokenAmount;
    }

    function calPresaleSwapTokenForETH(uint256 tokenAmount) external view returns (uint256) {
        uint256 ethAmount = _presaleETHCalculation(tokenAmount);
        uint256 ethForPlayer = ethAmount.mul(_presaleFeeRatio).div(1000);

        require(ethAmount <= address(this).balance, "Insufficient ETH balance in contract");

        return ethForPlayer;
    }

    function calPresaleSwapETHForExactToken(uint256 tokenAmount) external view returns (uint256) {
        require(tokenAmount <= _balances[address(this)], "Insufficient token balance in contract");
        uint256 ethAmount =
            (k / (_balances[address(this)] + initialToken - tokenAmount)) - (address(this).balance + initialETH);

        uint256 ethTotal = ethAmount.mul(1000).div(_presaleFeeRatio);

        return ethTotal;
    }

    function calPresaleSwapTokenForExactETH(uint256 ethAmount) external view returns (uint256) {
        uint256 ethTotal = ethAmount.mul(1000).div(_presaleFeeRatio);
        require(ethTotal <= address(this).balance, "Insufficient ETH balance in contract");

        uint256 tokenAmount =
            (k / (address(this).balance + initialETH - ethTotal)) - (_balances[address(this)] + initialToken);

        return tokenAmount;
    }
}
