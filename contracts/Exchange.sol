pragma solidity ^0.8.0;

contract Exchange {
    struct SellOrder {
        uint256 amount;
        address seller;
    }
    
    SellOrder[] internal sellOrders;
    
    constructor() {
        for(uint i = 0; i < 5; i++) {
            sellOrders.push(SellOrder(i*5, address(msg.sender)));
        }
    }
    
    function sellSideDepth() public view returns(uint256 totalAmount) {
        totalAmount = 0;
        
        for(uint i = 0; i < sellOrders.length; i++) {
            totalAmount += sellOrders[i].amount;    
        }
        
        return totalAmount;
    }
}