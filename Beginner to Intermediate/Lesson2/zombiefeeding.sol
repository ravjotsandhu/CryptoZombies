pragma solidity >=0.5.0 <0.6.0;

import "./zombiefactory.sol";

/*
For our contract to talk to another contract on the blockchain that we don't own, 
first we need to define an interface.
*/
//we feed Zombies cryptoKitties
contract KittyInterface {
    function getKitty(uint256 _id)
        external
        view
        returns (
            bool isGestating,
            bool isReady,
            uint256 cooldownIndex,
            uint256 nextActionAt,
            uint256 siringWithId,
            uint256 birthTime,
            uint256 matronId,
            uint256 sireId,
            uint256 generation,
            uint256 genes
        );
}

//Inheritence
contract ZombieFeeding is ZombieFactory {
    // address of the CryptoKitties contract
    address ckAddress = 0x06012c8cf97BEaD5deAe237070F9587f8E7A266d;
    //kittyContract is pointing to the CryptoKitties contract
    KittyInterface kittyContract = KittyInterface(ckAddress);

    // Storage refers to variables stored permanently on the blockchain.
    // Memory variables are temporary, and are erased between external function calls to your contract.
    // Think of it like your computer's hard disk vs RAM.
    //State variables are by default storage
    //while variables declared inside functions are memory
    function feedAndMultiply(
        uint256 _zombieId,
        uint256 _targetDna,
        string memory _species
    ) public {
        //We don't want to let someone else feed our zombie! So first, let's make sure we own this zombie.
        require(msg.sender == zombieToOwner[_zombieId]);

        //We're going to need to get this zombie's DNA
        Zombie storage myZombie = zombies[_zombieId];

        //calculating new dna
        _targetDna = _targetDna % dnaModulus;
        uint256 newDna = (myZombie.dna + _targetDna) / 2;

        //zombies made from kitties have some unique feature that shows they're cat-zombies.
        //We'll say that cat-zombies have 99 as their last two digits of DNA (since cats have 9 lives)
        if (
            keccak256(abi.encodePacked(_species)) ==
            keccak256(abi.encodePacked("kitty"))
        ) {
            newDna = newDna - (newDna % 100) + 99;
        }

        _createZombie("NoName", newDna);
    }

    function feedOnKitty(uint256 _zombieId, uint256 _kittyId) public {
        uint256 kittyDna;
        //store genes in kittyDna
        (, , , , , , , , , kittyDna) = kittyContract.getKitty(_kittyId);
        feedAndMultiply(_zombieId, kittyDna, "kitty");
    }
}
