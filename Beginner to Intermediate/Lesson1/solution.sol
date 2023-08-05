pragma solidity >=0.5.0 <0.6.0;

contract ZombieFactory {
    // declare our event here
    event NewZombie(uint256 zombieId, string name, uint256 dna);

    // state variables will be stored permanently in the blockchain
    uint256 dnaDigits = 16;
    uint256 dnaModulus = 10**dnaDigits;
    //Structs allow you to create more complicated data types that have multiple properties.
    struct Zombie {
        string name;
        uint256 dna;
    }

    //You can declare an array as public, and Solidity will automatically create a getter method for it
    //Other contracts would then be able to read from, but not write to, this array
    Zombie[] public zombies; // dynamic Array, we can keep adding to it

    //In Solidity, functions are public by default.
    //Obviously this isn't always desirable, and can make your contract vulnerable to attacks.
    //Thus it's good practice to mark your functions as private by default, and then only make public the functions you want to expose to the world
    function _createZombie(string memory _name, uint256 _dna) private {
        //creating struct and adding it to array
        uint256 id = zombies.push(Zombie(_name, _dna)) - 1;

        //FIRE THE EVENT HERE
        emit NewZombie(id, _name, _dna);
    }

    //view function, meaning it's only viewing the data but not modifying it
    //hash function keccak256 built in, which is a version of SHA3.
    //keccak256 expects a single parameter of type bytes. This means that we have to "pack" any parameters before calling keccak256
    //A hash function basically maps an input into a random 256-bit hexadecimal number.
    function _generateRandomDna(string memory _str)
        private
        view
        returns (uint256)
    {
        uint256 rand = uint256(keccak256(abi.encodePacked(_str)));
        return rand % dnaModulus;
    }

    function createRandomZombie(string memory _name) public {
        uint256 randDna = _generateRandomDna(_name);
        _createZombie(_name, randDna);
    }
}
