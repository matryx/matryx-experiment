pragma solidity ^0.4.0;

import "MatryxBounty.sol";

contract MatryxPlateform
{

    address owner;
    address[] public bounties;

    function Matryx()
    {
        owner = msg.sender;
    }

    function bounty(uint256 start, uint256 end, uint32 rounds, uint256 reviewDelay)
    {
        bounties.push(new MatryxBounty(start, end, rounds, reviewDelay));
    }

}
