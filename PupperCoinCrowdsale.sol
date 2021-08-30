pragma solidity ^0.5.0;

import "./PupperCoin.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/Crowdsale.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/emission/MintedCrowdsale.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/validation/CappedCrowdsale.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/validation/TimedCrowdsale.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/distribution/RefundablePostDeliveryCrowdsale.sol";

/* This crowdsale contract will manage the entire process, allowing users to send ETH and get back PUP (PupperCoin).
This contract will mint the tokens automatically and distribute them to buyers in one transaction.
*/

// Inherit the crowdsale contracts that we need for this project
contract PupperCoinSale is Crowdsale, MintedCrowdsale, CappedCrowdsale, TimedCrowdsale, RefundablePostDeliveryCrowdsale {

    constructor(
        // provide parameters for all of the features of the crowdsale :the name, symbol, wallet for fundraising
        uint rate, // rate in TKNbits
        address payable wallet, // sale beneficiary
        PupperCoin token, // the PupperCoin contract itself that the PupperCoinSale will work with i.e Organizing the Sale of PUP.
        
        // Set variables for the CappedCrowdsale inherited contract
        uint goal,
        
        // Set variables for the TimedCrowdsale inherited contract
        uint open,
        uint close
        )
    
        // Pass the constructor parameters to the crowdsale contracts / CappedCrowdsale / TimedCrowdsale and RefundableCrowdsale
        Crowdsale(rate, wallet, token)
        CappedCrowdsale(goal)
        TimedCrowdsale(open, close)
        RefundableCrowdsale(goal)
        
        public
    {
        // constructor can stay empty
    }
    
        // To test the closing time of the contract , we cchanged the close time to 5minutes

}

contract PupperCoinSaleDeployer {

    address public token_sale_address;
    address public token_address;

    constructor(
        // Fill in the constructor parameters!
        string memory name,
        string memory symbol,
        address payable wallet, // this address will receive all Ether raised by the sale
        uint goal
    )
        public
    {
        // create the PupperCoin and keep its address handy
        PupperCoin token = new PupperCoin(name, symbol, 0);
        token_address = address(token);

        // create the PupperCoinSale and tell it about the token, set the goal, and set the open and close times to now and now + 24 weeks
        PupperCoinSale pupper_token = new PupperCoinSale(
                            1, // 1 wei
                            wallet, // address collecting the tokens
                            token, // token sales
                            goal, // maximum supply of tokens = max fund we want to raise
                            now, // start of the contract (fundraising)
                            now + 24 weeks); // end of the contract (fundraising)
        // replace now by fakenow to get a test function
         token_sale_address= address(pupper_token);

        // make the PupperCoinSale contract a minter, then have the PupperCoinSaleDeployer renounce its minter role
        token.addMinter(token_sale_address);
        token.renounceMinter();
    }
            
}

