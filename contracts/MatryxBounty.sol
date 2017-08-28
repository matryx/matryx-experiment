pragma solidity ^0.4.13;

import './math/SafeMath.sol';
import './MatryxRound.sol';
import './ownership/Ownable.sol';
/**
 * @title MatryxBounty
 * @dev Representing each bounty
 */
contract MatryxBounty is Ownable
{

    using SafeMath for uint256;

    address[] public rounds;
    uint256 public start;
    uint256 public end;
    uint256 maxRounds;
    uint256 currRound;
    uint256 entryFee;

    /** State machine
    *
    * - Preparing: before all submissions
    * - Submitting: period in which submissions may be entered
    * - Reviewing: period of time for reward review
    */
    
    enum State{Preparing, Submitting, Reviewing}

    // modifiers
    modifier canSubmit() {
        require(getState() == State.Submitting);
        _;
    }
    

    function MatryxBounty(uint256 _start, uint256 _end, uint256 _rounds, uint256 _reviewDelay, uint256 _entryFee)
    {
        require(_start >= now);
        require(_end > _start);
        require(_rounds > 0);
        require(_reviewDelay > 0);
        require(_reviewDelay < _end.sub(_start).div(_rounds));
        require(_rounds < 100);
        require(_entryFee > 0);

        start = _start;
        end = _end;
        maxRounds = _rounds;
        currRound = 0;
        entryFee = _entryFee;



        // It's unlikely but there is a case where a bounty could have many rounds
        // that will make this constructor fail 

        // // Round open duration == (BountyEnd - BountyStart) / RoundNumber
        // uint256 roundOpenDuration = (_end.sub(_start)).div(_rounds);

        // // Round total duration == RoundOpenDuration + ReviewDelay
        // uint256 roundTotalDuration = roundOpenDuration.add(_reviewDelay);

        // for (uint256 i = 0; i < _rounds; i++)
        // {
        //     uint256 rstart = _start.add(roundTotalDuration.mul(i));
        //     uint256 rend = rstart.add(roundOpenDuration);
        //     uint256 rrefund = rstart.add(roundTotalDuration);
        //     rounds.push(new MatryxRound(
        //         rstart,
        //         rend,
        //         rrefund,
        //         _entryFee
        //     ));
        // }
    }

    function submit(bytes _submission, address _payout) canSubmit() payable {
        require(msg.value == entryFee);
        MatryxRound thisRound = MatryxRound(rounds[currRound]);
        thisRound.submit.value(msg.value)(_submission, _payout);
    }


    /**
    * Crowdfund state machine management
    *
    */
    function getState() public constant returns (State) {
        if(now < start) return State.Preparing;

    }

}
