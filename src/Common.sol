// SPDX-License-Identifier: MIT

pragma solidity 0.8.26;

contract Common {

  address[] private addresses;
  function _correctLength(  // @audit - проверить через tla+
    uint256 arrayLength,
    uint256 maxLength,
    uint256 fromIdx
  ) public pure returns (uint256) {
    if (arrayLength == 0 || maxLength == 0 || fromIdx >= arrayLength) {
      return 0;
    }

    uint256 availableLength = arrayLength - fromIdx;
    return maxLength > availableLength ? availableLength : maxLength;
  }

  /**
   * @dev Removes an element from an array by copying the last element into the specified index position
   *      and then removing the last element. This maintains array order but is gas efficient.
   * @param index The index of the element to remove
   * @param array The storage array to modify
   * @notice This function will revert if the index is out of bounds
   */
  function _removeFromArray(uint256 index, address[] storage array) internal {
    require(index < array.length, "Index out of bounds");

    // If this is not the last element, copy last element to the index position
    if (index != array.length - 1) {
      array[index] = array[array.length - 1];
    }
    array.pop();
  }

  // Add state variable
  

  function callRemoveFromArray(uint256 index) public {
    // Reset array to new length
    while(addresses.length > 0) {
      addresses.pop();
    }
    for (uint256 i = 0; i < index; i++) {
      addresses.push(address(uint160(uint256(keccak256(abi.encodePacked(block.timestamp, block.difficulty, i))))));
    }
    _removeFromArray(index - 1, addresses);
  }
}
