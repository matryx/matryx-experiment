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
    uint256 public maxRounds;
    uint256 public reviewDelay;
    uint256 public entryFee;
    uint256 public bounty;
    uint256 public roundBounty;

    uint256 public roundOpenDuration;
    uint256 public roundTotalDuration;

    /** State machine
    *
    * - Preparing: before all submissions
    * - Submitting: period in which submissions may be entered
    * - Reviewing: period of time for reward review
    * - Finalized: After the bounty has completed
    */
    
    enum State{Preparing, Submitting, Reviewing, Finalized}

    // modifiers
    modifier canSubmit(uint256 i) {
        require(getState(i) == State.Submitting);
        _;
    }

    modifier canPay(uint256 i) {
        require(getState(i) == State.Reviewing);
        _;
    }

    modifier canRefund(uint256 i) {
        require(getState(i) == State.Finalized);
        _;
    }
    

    function MatryxBounty(uint256 bounty, uint256 _start, uint256 _end, uint256 _rounds, uint256 _reviewDelay, uint256 _entryFee)
    {
        require(_start >= now);
        require(_end > _start);
        require(_rounds > 0 && _rounds < 100);
        require(_reviewDelay > 0 && _reviewDelay < _end.sub(_start).div(_rounds));
        require(_entryFee > 0);

        start = _start;
        end = _end;
        maxRounds = _rounds;
        reviewDelay = _reviewDelay;
        entryFee = _entryFee;
        bounty = 0;
        // Change ownership from MatryxPlatform contract to the bounty creator
        owner = tx.origin;

        // Round open duration == (BountyEnd - BountyStart) / RoundNumber
        roundOpenDuration = (_end.sub(_start)).div(_rounds);

        // Round total duration == RoundOpenDuration + ReviewDelay
        roundTotalDuration = roundOpenDuration.add(_reviewDelay);

        // calculate the bounty per round
        roundBounty = bounty.div(_rounds);

        for (uint256 i = 0; i < _rounds; i++)
        {
            uint256 rstart = _start.add(roundTotalDuration.mul(i));
            uint256 rend = rstart.add(roundOpenDuration);
            uint256 rrefund = rstart.add(roundTotalDuration);
            rounds.push(new MatryxRound(
                rstart,
                rend,
                rrefund,
                _entryFee,
                roundBounty,
                i
            ));
        }
    }

    function supplyBounty() payable {
        bounty = bounty.add(msg.value);
    }

    function submit(bytes _submission, address _payout, uint256 _roundNum) canSubmit(_roundNum) payable {
        require(msg.value == entryFee);
        MatryxRound thisRound = MatryxRound(rounds[_roundNum]);
        thisRound.submit.value(msg.value)(_submission, _payout);
    }

    function pay(address _submitter, uint256 _roundNum) onlyOwner canPay(_roundNum) {
        MatryxRound r = MatryxRound(rounds[_roundNum]);
        uint256 rating = r.getRating(_submitter);
        uint256 totalRating = r.getTotalRating();

        uint256 compensation = roundBounty.mul(rating).div(totalRating);
        r.pay.value(compensation)(_submitter);
    }

    function refund(uint256 _roundNum) canRefund(_roundNum) {
        MatryxRound r = MatryxRound(rounds[_roundNum]);
        r.refund();
    }

    function rate(uint256 _roundNum, address _submitter, uint256 rating) onlyOwner canPay(_roundNum) {
        MatryxRound r = MatryxRound(rounds[_roundNum]);
        r.rate(_submitter, rating);
    }

    function closeRound(uint256 _roundNum, address _winner, uint256 _totalRating) onlyOwner canPay(_roundNum) {
        MatryxRound r = MatryxRound(rounds[_roundNum]);
        r.close(_winner, _totalRating);
    }
    /**
    * Bounty state machine management
    *
    */
    function getState(uint256 _roundNum) public constant returns (State) {
        require(_roundNum > 0 && _roundNum <= maxRounds);

        uint256 roundStart = MatryxRound(rounds[_roundNum]).getStart();
        uint256 roundEnd = MatryxRound(rounds[_roundNum]).getEnd();
        uint256 refundStart = MatryxRound(rounds[_roundNum]).getRefundTime();

        if(now < roundStart) {
            return State.Preparing;
        } else if(now < roundEnd && now > roundStart) {
            return State.Submitting;
        } else if(now < refundStart && now > roundEnd) {
            return State.Reviewing;
        } else {
            return State.Finalized;
        }
    }

}
