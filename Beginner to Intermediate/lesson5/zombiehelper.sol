pragma solidity >=0.5.0 <0.6.0;

import "./zombiefeeding.sol";

contract ZombieHelper is ZombieFeeding {
  //define levelupFee
  uint levelUpFee = 0.001 ether;

  modifier aboveLevel(uint _level, uint _zombieId) {
    require(zombies[_zombieId].level >= _level);
    _;
  }
   /* 
   _owner variable have to be a address payable type for doing a sending and transferring ether instruction
   */
   //But our owner() isn't a type address payable so we have to explicitly cast to address payable. 
   //Casting any integer type like uint160 to address produces an address payable
  function withdraw() external onlyOwner {
    address payable _owner = address(uint160(owner()));
    _owner.transfer(address(this).balance);
  }
//create a function that allows us as the owner of the contract to set the levelUpFee.
  function setLevelUpFee(uint _fee) external onlyOwner {
    levelUpFee = _fee;
  }

  ///levelup function
  //we make it payable
  // our game has a feature where users can pay ETH to level up their zombies. 
  //The ETH will get stored in the contract, which you own 
  function levelUp(uint _zombieId) external payable {
    require(msg.value == levelUpFee);
    zombies[_zombieId].level++;
  }

  function changeName(uint _zombieId, string calldata _newName) external aboveLevel(2, _zombieId) ownerOf(_zombieId){
    zombies[_zombieId].name = _newName;
  }

  function changeDna(uint _zombieId, uint _newDna) external aboveLevel(20, _zombieId) ownerOf(_zombieId){
    zombies[_zombieId].dna = _newDna;
  }

  function getZombiesByOwner(address _owner) external view returns(uint[] memory) {
    uint[] memory result = new uint[](ownerZombieCount[_owner]);
    uint counter = 0;
    for (uint i = 0; i < zombies.length; i++) {
      if (zombieToOwner[i] == _owner) {
        result[counter] = i;
        counter++;
      }
    }
    return result;
  }

}
