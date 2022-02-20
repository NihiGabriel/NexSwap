pragma solidity >=0.4.22 <0.9.0;

import "./Token.sol";

contract EthSwap {
   string public name = 'EthSwap Instant Exchange';
   Token public token; 
   uint public rate = 100;

   event TokensPurchased(
      address account,
      address token,
      uint amount,
      uint rate
   );

   event TokensSold(
      address account,
      address token,
      uint amount,
      uint rate
   );

   constructor(Token _token) public {
      token = _token;
   }

   function buyTokens() public payable{
      // redemption rate = num of tokens they recieve for 1 Eth
      //rate
      // amount of eth * Redemption rate
      // calculate the number of tokens to buy
      uint tokenAmount = msg.value * rate;

      // Require that EthSwap ahs enough token
      require(token.balanceOf(address(this)) >= tokenAmount);

      // Transfer tokens to the user
      token.transfer(msg.sender, tokenAmount);

      // emit an event
      emit TokensPurchased(msg.sender, address(token), tokenAmount, rate);
   }

   function sellTokens(uint _amount) public {
      // Users can't sell more tokens than they have 
      require(token.balanceOf(msg.sender) >= _amount);

      //calculate the amount of ether to redeem
      uint etherAmount = _amount / rate;

      // Require that EthSwap has enough ether
      require (address(this).balance >= etherAmount);
      
      // Perform sale
      token.transferFrom(msg.sender, address(this), _amount);
      msg.sender.transfer(etherAmount);

      // Emit an event
      emit TokensSold(msg.sender, address(token), _amount, rate);
   }

}
