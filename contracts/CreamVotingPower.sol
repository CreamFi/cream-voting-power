//SPDX-License-Identifier: MIT
pragma solidity 0.6.12;

import "@openzeppelin/contracts/math/SafeMath.sol";
import "@openzeppelin/contracts/utils/Address.sol";
import "@openzeppelin/contracts/token/ERC20/SafeERC20.sol";
import "../interfaces/IBPool.sol";
import "../interfaces/IMasterChef.sol";
import "../interfaces/IUniswapV2Pair.sol";
import "../interfaces/ICDelegator.sol";
import "../interfaces/ILPool.sol";

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

    address public constant cream = 0x2ba592F78dB6436527729929AAf6c908497cB200;
    address public constant crCream =
        0x892B14321a4FCba80669aE30Bd0cd99a7ECF6aC0;
    address[] public lPool = [
        address(0x780F75ad0B02afeb6039672E6a6CEDe7447a8b45),
        address(0xBdc3372161dfd0361161e06083eE5D52a9cE7595),
        address(0xD5586C1804D2e1795f3FBbAfB1FBB9099ee20A6c),
        address(0xE618C25f580684770f2578FAca31fb7aCB2F5945)
    ];
    address public constant sushiswap =
        0xf169CeA51EB51774cF107c88309717ddA20be167;
    address public constant masterchef =
        0xc2EdaD668740f1aA35E4D8f227fB8E17dcA888Cd;
    address public constant uniswap =
        0xddF9b7a31b32EBAF5c064C80900046C9e5b7C65F;
    address public constant balancer =
        0x280267901C175565C64ACBD9A3c8F60705A72639;

    uint256 public MINIMUM_VOTING_POWER = 1;

    function getVotingPower(address _holder) public view returns (uint256) {
        require(_holder != address(0), "VotingPower.getVotingPower: Zero Address");
        uint256 votingPower =
            _creamBalance(_holder)
                .add(_lendingSupply(_holder))
                .add(_sushiswapBalance(_holder))
                .add(_uniswapBalance(_holder))
                .add(_balancerBalance(_holder))
                .add(_stakedInLPool(_holder))
                .sub(_borrowedBalance(_holder));

        require(
            votingPower > MINIMUM_VOTING_POWER,
            "VotingPower.getVotingPower: Invalid"
        );
        return votingPower;
    }

    /////////////////////////
    // Internal and Private /
    /////////////////////////
    /**
     @notice CREAM in the wallet
     @param _holder Address of holder
     @return uint256 The cream token amount
    */
    function _creamBalance(address _holder) internal view returns (uint256) {
        require(
            _holder != address(0),
            "VotingPower.creamBalance: Zero Address"
        );

        return IERC20(cream).balanceOf(_holder);
    }

    /**
     @notice CREAM supplied in Cream Lending, based on your crCREAM in the wallet
     @param _holder Address of holder
     @return uint256 The cream token amount
    */
    function _lendingSupply(address _holder) internal view returns (uint256) {
        require(
            _holder != address(0),
            "VotingPower.lendingSupply: Zero Address"
        );

        return ICDelegator(crCream).balanceOf(_holder);
    }

    /**
     @notice CREAM from your CREAM-ETH LP in Uniswap
     @param _holder Address of holder
     @return uint256 The cream token amount
    */
    function _uniswapBalance(address _holder) internal view returns (uint256) {
        uint256 staked = IUniswapV2Pair(uniswap).balanceOf(_holder);
        uint256 lpTotalSupply = IUniswapV2Pair(uniswap).totalSupply();
        (uint112 _reserve0,,) = IUniswapV2Pair(uniswap).getReserves();

        staked = uint256(_reserve0).mul(staked).div(lpTotalSupply);

        return staked;
    }

    /**
     @notice CREAM from your CREAM-ETH (SLP) token in the wallet & MasterChef
     @param _holder Address of holder
     @return uint256 The cream token amount
    */
    function _sushiswapBalance(address _holder) internal view returns (uint256) {
        (uint256 staked, ) = IMasterChef(masterchef).userInfo(22, _holder);
        uint256 lpInWallet = IUniswapV2Pair(sushiswap).balanceOf(_holder);
        uint256 lpTotalSupply = IUniswapV2Pair(sushiswap).totalSupply();
        (uint112 _reserve0,,) = IUniswapV2Pair(sushiswap).getReserves();
        uint256 creamPerLPToken = uint256(_reserve0).div(lpTotalSupply);

        return staked.add(lpInWallet).mul(creamPerLPToken);
    }

    /**
     @notice CREAM from your CREAM-ETH BPT in Balancer
     @param _holder Address of holder
     @return uint256 The cream token amount
    */
    function _balancerBalance(address _holder) internal view returns (uint256) {
        uint256 staked = IBPool(balancer).balanceOf(_holder);
        uint256 crInBalancer = IBPool(balancer).getBalance(cream);
        uint256 lpTotalSupply = IBPool(balancer).totalSupply();

        return crInBalancer.mul(staked).div(lpTotalSupply);
    }

    /**
     @notice CREAM staked in long-term pools
     @param _holder Address of holder
     @return uint256 The cream token amount
    */
    function _stakedInLPool(address _holder) internal view returns (uint256) {
        require(
            _holder != address(0),
            "VotingPower.lendingSupply: Zero Address"
        );

        uint256 totalStaked = 0;

        for (uint256 i = 0; i < 4; i++) {
            totalStaked.add(ILPool(lPool[i]).balanceOf(_holder));
        }

        return totalStaked;
    }

    /**
     @notice CREAM borrowed in Cream Lending
     @param _holder Address of holder
     @return uint256 The cream token amount
    */
    function _borrowedBalance(address _holder) internal view returns (uint256) {
        require(
            _holder != address(0),
            "VotingPower.lendingSupply: Zero Address"
        );

        return ICDelegator(crCream).borrowBalanceStored(_holder);
    }
}
