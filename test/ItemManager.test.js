const ItemManager = artifacts.require("./ItemManager.sol");

contract("ItemManager", accounts => {
    it("should be able to add an item", async () => {
        const itemManagerInstance = await ItemManager.deployed();
        const itemName = "test-1";
        const itemPrice = 500;

        const result = await itemManagerInstance.createItem(itemName, 500, { from: accounts[0] })
        assert.equal(result.logs[0].args._itemIndex, 0, "It is not the first item");

        const item = await itemManagerInstance.items(0);
        assert.equal(item._identifier, itemName, "The name is incorrect");
        assert.equal(item._itemPrice, itemPrice, "The name is incorrect");
        assert.equal(item._state, 0, "The state is incorrect");
    })
})