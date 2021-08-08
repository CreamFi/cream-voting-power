//SPDX-License-Identifier: MIT
pragma solidity 0.8.6;

import "@openzeppelin/contracts/utils/Address.sol";
import "../interfaces/ILPool.sol";

contract CreamVotingPower {
    using Address for address payable;

    address public constant iceCream = 0x3986425b96F11972d31C78ff340908832C5c0043;

    address[] public lPool = [
        address(0x780F75ad0B02afeb6039672E6a6CEDe7447a8b45),
        address(0xBdc3372161dfd0361161e06083eE5D52a9cE7595),
        address(0xD5586C1804D2e1795f3FBbAfB1FBB9099ee20A6c),
        address(0xE618C25f580684770f2578FAca31fb7aCB2F5945)
    ];

    uint256 public MINIMUM_VOTING_POWER = 1e18;

    function balanceOf(address _holder) public view returns (uint256) {
        require(_holder != address(0), "VotingPower.getVotingPower: Zero Address");
        uint256 votingPower = _stakedInLPool(_holder);

        return votingPower >= MINIMUM_VOTING_POWER ? votingPower : 0;
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
            totalStaked = totalStaked + ILPool(lPool[i]).balanceOf(_holder);
        }

        return totalStaked;
    }
}
