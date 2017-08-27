pragma solidity ^0.4.13;

/**
 * @title Matryx 
 * @dev Alpha version of the Matryx bounty system. This is a controller
 * contract to register the bounties and create new bounty contracts
 *
 * This contract is meant to provided as a proof of concept only
 */
contract MatryxBounty
{

    address public owner;
    address[] public bounties;
    uint256 public start;
    uint256 public end;
    uint256 public rounds;
    uint256 public reviewDelay;

    function MatryxBounty(uint256 _start, uint256 _end, uint256 _rounds, uint256 _reviewDelay)
    {
        require(_start >= now);
        require(_end >= _start);
        require(_rounds > 0);
        // consider putting a max on review time
        require(_reviewDelay > 0);

        owner = msg.sender;
        start = _start;
        end = _end;
        rounds = _rounds;
        reviewDelay = _reviewDelay;
    }

}
