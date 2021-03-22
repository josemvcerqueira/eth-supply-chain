// SPDX-License-Identifier: GL-3.0

pragma solidity >=0.4.0 <0.9.0;

import "./ItemManager.sol";

contract Item {
    uint256 public priceInWei;
    uint256 public index;
    uint256 public pricePaid;

    ItemManager parentContract;

    constructor(
        ItemManager _parentContract,
        uint256 _priceInWei,
        uint256 _index
    ) {
        priceInWei = _priceInWei;
        index = _index;
        parentContract = _parentContract;
    }

    receive() external payable {
        require(pricePaid == 0, "This item has already been paid for.");
        require(priceInWei == msg.value, "Only full payments allowed");
        pricePaid += msg.value;

        (bool success, ) =
            payable(address(parentContract)).call{value: msg.value}(
                abi.encodeWithSignature("triggerPayment(uint256)", index)
            );
        require(success, "The transaction wasn't successful, cancelling");
    }

    fallback() external {}
}
