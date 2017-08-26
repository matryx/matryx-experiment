pragma solidity ^0.4.0;



contract Matryx
{

    address owner;
    address[] public bounties;

    function Matryx()
    {
        owner = msg.sender;
    }

    function bounty(uint256 start, uint256 end, uint32 rounds, uint256 reviewDelay)
    {
        bounties.push(new Bounty(start, end, rounds, reviewDelay));
    }

}
