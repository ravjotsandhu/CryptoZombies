pragma solidity >=0.5.0 <0.6.0;

contract ZombieFactory {

    event NewZombie(uint zombieId, string name, uint dna);

    uint dnaDigits = 16;
    uint dnaModulus = 10 ** dnaDigits;

    struct Zombie {
        string name;
        uint dna;
    }

    Zombie[] public zombies;
    //A mapping is essentially a key-value store for storing and looking up data.
    // declare mappings here
    mapping (uint => address) public zombieToOwner;
    mapping (address => uint) ownerZombieCount;

    //In addition to public and private, Solidity has two more types of visibility for functions: internal and external
    //internal is the same as private, except that it's also accessible to contracts that inherit from this contract.
    //external is similar to public, except that these functions can ONLY be called outside the contract — they can't be called by other functions inside that contract.

    function _createZombie(string memory _name, uint _dna) internal {
        
        uint id = zombies.push(Zombie(_name, _dna)) - 1;
        
        // msg.sender, which refers to the address of the person (or smart contract) who called the current function
        zombieToOwner[id] = msg.sender;
        ownerZombieCount[msg.sender]++;

        emit NewZombie(id, _name, _dna);
    } 

    function _generateRandomDna(string memory _str) private view returns (uint) {
        uint rand = uint(keccak256(abi.encodePacked(_str)));
        return rand % dnaModulus;
    }

    function createRandomZombie(string memory _name) public {
        uint randDna = _generateRandomDna(_name);
        //require makes it so that the function will throw an error and stop executing if some condition is not true
        //function only gets executed one time per user, when they create their first zombie
        require(ownerZombieCount[msg.sender] == 0);
        _createZombie(_name, randDna);
    }

}
