pragma solidity ^0.4.13;

import 'zeppelin-solidity/contracts/token/StandardToken.sol';

contract CatToken is StandardToken {
  string public name = "CAT COIN";
  string public symbol = "CAT";
  uint public decimals = 2;
  uint public INITIAL_SUPPLY = 12000;

  function CatToken() {
  totalSupply = INITIAL_SUPPLY;
  balances[msg.sender] = INITIAL_SUPPLY;
  }
}
