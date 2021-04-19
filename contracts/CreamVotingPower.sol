//SPDX-License-Identifier: MIT
pragma solidity ^0.7.3;

import "@openzeppelin/contracts/math/SafeMath.sol";
import "@openzeppelin/contracts/utils/Address.sol";
import "@openzeppelin/contracts/token/ERC20/SafeERC20.sol";
import "../interfaces/IBPool.sol"'
import "../interfaces/IMasterChef.sol";
import "../interfaces/IUniswapV2Pair.sol";


contract CreamVotingPower {
    using SafeMath for uint256;
    using Address for address payable;
    using SafeERC20 for IERC20;

    struct VotingPower {
        uint256 wallet;
        uint256 crCream;
        uint256 sushiswap;
        uint256 masterChef;
        uint256 uniswap;
        uint256 balancer;
        uint256 pool;
        uint256 lending;
    }

    struct UserInfo {
        uint256 amount;
        uint256 rewardDebt;
    }

    address public cream = "0x2ba592f78db6436527729929aaf6c908497cb200";
    address public pool = "";
    address public lending = "";
    address public sushiswap = "0xf169cea51eb51774cf107c88309717dda20be167";
    address public masterchef = "0xc2edad668740f1aa35e4d8f227fb8e17dca888cd";
    address public uniswap = "0xddf9b7a31b32ebaf5c064c80900046c9e5b7c65f";
    address public balancer = "0x280267901c175565c64acbd9a3c8f60705a72639";
    
    function balanceOf(address token, address holder) returns (uint256) {
        require(
            token != address(0),
            "VotingPower.balanceOf: Zero Address"
        );
        require(
            holder != address(0),
            "VotingPower.balanceOf: Zero Address"
        );
        return IERC20(token).balanceOf(holder);
    }

    /////////////////////////
    // Internal and Private /
    /////////////////////////
    function _creamBalance(address _holder) private {
        require(
            _holder != address(0),
            "VotingPower.walletBalance: Zero Address"
        );

        return IERC20(cream).balanceOf(_holder);
    }

    function _suppliedLending(address _holder) private {

    }

    /**
     @notice CREAM from your CREAM-ETH LP in Uniswap
     @param _holder Address of holder
     @return uint256 The cream token amount
    */
    function _uniswapBalance(address _holder) internal returns(uint256) {
        uint256 staked = IUniswapV2Pair(uniswap).balanceOf(_holder);
        uint256 lpTotalSupply = IUniswapV2Pair(uniswap).totalSupply();
        (uint112 _reserve0, uint112 _reserve1,) = IUniswapV2Pair(uniswap).getReserves();

        staked = uint256(_reserve0) * staked / lpTotalSupply;

        return staked;
    }

    /**
     @notice CREAM from your CREAM-ETH (SLP) token in the wallet & MasterChef
     @param _holder Address of holder
     @return uint256 The cream token amount
    */
    function _sushiswapBalance(address _holder) internal returns(uint256) {
        uint256 staked = IMasterChef(masterchef).userInfo(22, holder).amount;
        uint256 lpInWallet = IUniswapV2Pair(sushiswap).balanceOf(_holder);
        uint256 lpTotalSupply = IUniswapV2Pair(sushiswap).totalSupply();
        (uint112 _reserve0, uint112 _reserve1,) = IUniswapV2Pair(sushiswap).getReserves();

        staked = uint256(_reserve0) * staked / lpTotalSupply;
        lpInWallet = uint256(_reserve0) * lpInWallet / lpTotalSupply;

        return staked + lpInWallet;
    }

    /**
     @notice CREAM from your CREAM-ETH BPT in Balancer
     @param _holder Address of holder
     @return uint256 The cream token amount
    */
    function _balancerBalancec(address _holder) internal returns(uint256) {
        uint256 staked = IBPool(balancer).balanceOf(_holder);
        uint256 crInBalancer = IBPool(balancer).getBalance(cream);
        uint256 lpTotalSupply = IBPool(balancer).totalSupply();

        return crInBalancer * staked / lpTotalSupply;
    }

}
