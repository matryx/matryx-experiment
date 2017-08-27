pragma solidity ^0.4.13;

import './Round.sol';

/**
 * @title Round
 * 
 */
contract Round
{

    struct Submission {
        address owner;
        string URL;
        uint256 rating;
        uint256 timeSubmitted;
        bool refunded;
    }


    uint256 public roundNumber;
    address[] public subAddresses;
    mapping(address => Submission) submissions;

    function Round(uint256 _start, uint256 _end, uint256 _rounds, uint256 _reviewDelay)
    {

    }

    function submit() {

    }

    function setWinner() {

    }

    function reclaimFunds() {

    }

    function getRound() internal {

    }
}
