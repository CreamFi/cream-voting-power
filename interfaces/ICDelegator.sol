//SPDX-License-Identifier: MIT
pragma solidity 0.6.12;

interface ICDelegator {

    function balanceOf(address owner) external view returns (uint);
    function borrowBalanceStored(address account) external view returns (uint);
}