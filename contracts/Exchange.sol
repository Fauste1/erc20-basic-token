pragma solidity ^0.8.0;

contract Exchange {
    uint256 public EBTBalance;
    uint8 public exchangeRate; // How many EBT you get for 1 ETH
    uint256 public ethVault;

    receive() external payable {

    }
    
    function makeExchange() public payable {
        ethVault += msg.value;
    }
}