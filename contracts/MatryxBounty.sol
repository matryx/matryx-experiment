pragma solidity ^0.4.13;

import './math/SafeMath.sol';

import './MatryxRound.sol';

/**
 * @title MatryxBounty
 * @dev Representing each bounty
 */
contract MatryxBounty
{

    using SafeMath for uint256;

    address public owner;

    address[] public rounds;

    function MatryxBounty(uint256 _start, uint256 _end, uint256 _rounds, uint256 _reviewDelay, uint256 _entryFee)
    {
        require(_start >= now);
        require(_end > _start);
        require(_rounds > 0);
        require(_reviewDelay > 0);
        require(_reviewDelay < _end.sub(_start).div(_rounds));
        require(_rounds < 100);

        owner = msg.sender;

        // Round open duration == (BountyEnd - BountyStart) / RoundNumber
        uint256 roundOpenDuration = (_end.sub(_start)).div(_rounds);

        // Round total duration == RoundOpenDuration + ReviewDelay
        uint256 roundTotalDuration = roundOpenDuration.add(_reviewDelay);

        for (uint256 i = 0; i < _rounds; i++)
        {
            uint256 rstart = _start.add(roundTotalDuration.mul(i));
            uint256 rend = rstart.add(roundOpenDuration);
            uint256 rrefund = rstart.add(roundTotalDuration);
            rounds.push(new MatryxRound(
                rstart,
                rend,
                rrefund,
                _entryFee
            ));
        }
    }

    /** State machine
    *
    * - Preparing: before all submissions
    * - Submitting: period in which submissions may be entered
    * - Reviewing: period of time for reward review
    */
    /*
    enum State{Preparing, Submitting, Reviewing}

    // modifiers
    modifier canSubmit() {
        bool submit = now >= start && now <= end;
        if(!submit) throw;
        _;
    }
    */

}
