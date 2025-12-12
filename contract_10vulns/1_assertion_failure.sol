pragma solidity ^0.4.26;

contract SlateBook {
    mapping(bytes32 => address) public slates;
    bool public everMatched = false;

    function etch(address yay) public returns (bytes32 slate) {
        bytes32 hash = keccak256(abi.encodePacked(yay));
        slates[hash] = yay;
        return hash;
    }

    function lookup(bytes32 slate, address nay) public {
        if (nay != address(0x0)) {
            everMatched = (slates[slate] == nay);
        }
    }

    function checkAnInvariant() public returns (bool) {
        assert(!everMatched);
        return true;
    }
}

contract Driver {
    SlateBook public book;

    constructor(address _book) public {
        book = SlateBook(_book);
    }

    function etch(address yay) public returns (bytes32 slate) {
        return book.etch(yay);
    }

    function lookup(bytes32 slate, address nay) public {
        book.lookup(slate, nay);
    }

    function checkAnInvariant() public returns (bool) {
        return book.checkAnInvariant();
    }
}

contract Deployer {
    function deploy() public returns (address bookAddr, address driverAddr) {
        SlateBook book = new SlateBook();
        Driver driver = new Driver(address(book));
        return (address(book), address(driver));
    }
}

