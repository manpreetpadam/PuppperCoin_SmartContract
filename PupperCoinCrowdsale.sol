pragma solidity ^0.5.0;

import "./PupperCoin.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/crowdsale/Crowdsale.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/crowdsale/emission/MintedCrowdsale.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/crowdsale/validation/CappedCrowdsale.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/crowdsale/validation/TimedCrowdsale.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/crowdsale/distribution/RefundablePostDeliveryCrowdsale.sol";

// @TODO: Inherit the crowdsale contracts
contract PupperCoinSale is Crowdsale, MintedCrowdsale,TimedCrowdsale,RefundableCrowdsale {

    constructor(uint rate,    // rate in TKNbits
                address payable wallet,
                PupperCoin token,
                uint openingTime,     // opening time in unix epoch seconds
                uint closingTime,
                uint goal)

        MintedCrowdsale()
        RefundableCrowdsale(goal)
        TimedCrowdsale(openingTime,closingTime)
        Crowdsale(rate,wallet,token)
        public
    {
        // constructor can stay empty
    }
}

contract PupperCoinSaleDeployer {

    address public token_sale_address;
    address public token_address;

    constructor(
        string memory name,
        string memory symbol,
        address payable wallet
    )
        public
    {
        // @TODO: create the PupperCoin and keep its address handy
        PupperCoin token=new PupperCoin(name,symbol,0);
        token_address=address(token);

        // @TODO: create the PupperCoinSale and tell it about the token, set the goal, and set the open and close times to now and now + 24 weeks.
        uint opening_time = now;
        uint closing_time = now + 24 weeks;
        PupperCoinSale pupper_coin=new PupperCoinSale(1,wallet,token,opening_time,closing_time,300);
        token_sale_address=address(pupper_coin);
        // make the PupperCoinSale contract a minter, then have the PupperCoinSaleDeployer renounce its minter role
        token.addMinter(token_sale_address);
        token.renounceMinter();
    }
}