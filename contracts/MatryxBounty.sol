pragma solidity ^0.4.13;

import './Round.sol';
import './math/SafeMath.sol';

/**
 * @title MatryxBounty
 * @dev Representing each bounty
 *
 * 
 */
contract MatryxBounty
{
    using SafeMath for uint256;
    address public owner;
    address[] public bounties;
    uint256 public start;
    uint256 public end;
    uint256 public rounds;
    uint256 public reviewDelay;
    uint256 public currRound;

    /** State machine
    *
    * - Preparing: before all submissions
    * - Submitting: period in which submissions may be entered
    * - Reviewing: period of time for reward review
    */
    enum State{Preparing, Submitting, Reviewing}

    // modifiers
    modifier canSubmit() {
        bool submit = now >= start && now <= end;
        if(!submit) throw;
        _;
    }

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

    function submit() canSubmit() {

    }

    function setWinner() {
        currRound = currRound.add(1);
    }

    function reclaimFunds() {

    }

    function getRound() internal {

    }
}
