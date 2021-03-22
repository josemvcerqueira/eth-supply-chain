// SPDX-License-Identifier: GL-3.0

pragma solidity >=0.4.0 <0.9.0;

contract Ownable {
    address _owner;

    constructor() {
        _owner = msg.sender;
    }

    function isOwner() public view returns (bool) {
        return (msg.sender == _owner);
    }

    modifier onlyOwner() {
        require(isOwner(), "You are not the owner");
        _;
    }
}
