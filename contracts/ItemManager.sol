// SPDX-License-Identifier: GL-3.0

pragma solidity >=0.4.0 <0.9.0;

import "./Ownable.sol";
import "./Item.sol";

contract ItemManager is Ownable {
    enum SupplyChainState {Created, Paid, Delivered}

    struct S_Item {
        Item _item;
        string _identifier;
        uint256 _itemPrice;
        ItemManager.SupplyChainState _state;
    }

    mapping(uint256 => S_Item) public items;

    uint256 itemIndex;

    event SupplyChainStep(
        uint256 _itemIndex,
        uint256 _step,
        address _itemAddress
    );

    function triggerEvent(uint256 _itemIndex, address _itemAddress) private {
        emit SupplyChainStep(
            itemIndex,
            uint256(items[_itemIndex]._state),
            _itemAddress
        );
    }

    function createItem(string memory _identifier, uint256 _itemPrice)
        public
        onlyOwner
    {
        items[itemIndex]._item = new Item(this, _itemPrice, itemIndex);
        items[itemIndex]._identifier = _identifier;
        items[itemIndex]._itemPrice = _itemPrice;
        items[itemIndex]._state = SupplyChainState.Created;

        triggerEvent(itemIndex, address(items[itemIndex]._item));
        itemIndex++;
    }

    function triggerPayment(uint256 _itemIndex) public payable {
        require(
            items[_itemIndex]._itemPrice == msg.value,
            "Only full payments accepted"
        );
        require(
            items[_itemIndex]._state == SupplyChainState.Created,
            "Item has been paid for or delivered already"
        );

        items[_itemIndex]._state = SupplyChainState.Paid;
        triggerEvent(itemIndex, address(items[itemIndex]._item));
    }

    function triggerDelivery(uint256 _itemIndex) public onlyOwner {
        require(
            items[_itemIndex]._state == SupplyChainState.Paid,
            "Item is not read to be delivered"
        );
        items[_itemIndex]._state = SupplyChainState.Delivered;
        triggerEvent(itemIndex, address(items[itemIndex]._item));
    }
}
