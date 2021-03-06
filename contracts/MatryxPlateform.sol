pragma solidity ^0.4.13;

import './MatryxBounty.sol';
import './ownership/Ownable.sol';

/**
 * @title Matryx 
 * @dev Alpha version of the Matryx bounty system. This is a controller
 * contract to register the bounties and create new bounty contracts
 *
 * This contract is meant to provided as a proof of concept only
 */
contract MatryxPlateform is Ownable
{
    address[] public bounties;

    // Creates new bounty contracts and registers them
    function createBounty(uint256 start, uint256 end, uint32 rounds, uint256 reviewTime, uint256 entryFee)
    {
        bounties.push(new MatryxBounty(start, end, rounds, reviewTime, entryFee));
    }

}
