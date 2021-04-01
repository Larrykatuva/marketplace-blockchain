pragma solidity ^0.5.0;

contract Marketplace {
    string public name;

    // product count
    uint public productCount = 0;

    /*
    * product mapping
    * can be accessed outside the contract (public)
    */
    mapping(uint => Product) public products;

    /**
    * pattern for seller product
    */
    struct Product {
        uint id;
        string name;
        uint price;
        address payable owner;
        bool purchased;
    }


    /**
    * product created event
    */
    event ProductCreated (
        uint id,
        string name,
        uint price,
        address payable owner,
        bool purchased
    );

    /**
    * product purchased event
    */
    event ProductPurchased(
        uint id,
        string name,
        uint price,
        address payable owner,
        bool purchased
    );


    // constructor
    constructor() public {
        name = "Dapp university Marketplace";
    }

    /**
    * creating a new product
    */
    function createProduct(
        string memory _name, 
        uint _price
    ) public {
        // require a valid name
        require(bytes(_name).length > 0);
        // require valid price
        require(_price > 0);

        // increament product count
        productCount ++;

        // create a product
        products[productCount] = Product(
            productCount, 
            _name, 
            _price, 
            msg.sender, 
            false
        );

        // trigger an event
        emit ProductCreated(
            productCount, 
            _name, 
            _price, 
            msg.sender, 
            false
        );
    }

    function purchaseProduct(
        uint _id
    ) public payable{
        // fetch the product
        Product memory _product = products[_id];
        // fetch the owner
        address payable _seller = _product.owner;
        // make sure the prodcut is valid
        // transfer ownership
        _product.owner = msg.sender;
        // mark as purchased
        _product.purchased = true;
        // update the product
        products[_id] = _product;
        //pay seller by semding them ether
        address(_seller).transfer(msg.value);
        // trigger an event
        emit ProductPurchased(
            productCount, 
            _product.name, 
            _product.price, 
            msg.sender, 
            true
        );
    }
}
