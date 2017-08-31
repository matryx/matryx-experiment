pragma solidity ^0.4.13;

import './math/SafeMath.sol';
import './ownership/Ownable.sol';

/**
 */
contract MatryxRound is Ownable
{

    using SafeMath for uint256;

    struct MatryxSubmission
    {
        address owner;
        address payout;
        bytes url; // Now store content within URL, will use Decentralized storage in the future
        uint256 rating;
        uint256 time;
        bool refunded;
    }

    bool closed;

    uint256 public bounty;
    uint256 public entryFee;
    uint256 public collectedFees;

    //MatryxSubmission[] public submissions;
    address[] public subAddresses;
    mapping(address => MatryxSubmission) submissions;

    uint256 public startTime;
    uint256 public endTime;
    uint256 public refundTime;
    uint256 public roundNumber;
    uint256 public numSubmissions;
    uint256 public totalRating = 0;

    address public winner;

    function MatryxRound(uint256 _start, uint256 _end, uint256 _refund, uint256 _entryFee, uint256 _bounty, uint256 _roundNumber)
    {
        bounty = _bounty;
        entryFee = _entryFee;

        require(entryFee > 0);
        require(bounty > 0);

        startTime = _start;
        endTime = _end;
        refundTime = _refund;
        roundNumber = _roundNumber;
        numSubmissions = 0;

        require(startTime > now);
        require(startTime < endTime);
        require(refundTime > endTime);

        closed = false;

        // keep ownership on the bounty contract
    }

    function submit(bytes url, address payout) onlyOwner payable
    {
        require(msg.value >= entryFee);

        collectedFees = collectedFees.add(msg.value);

        MatryxSubmission memory submission;
        submission.owner = msg.sender;
        submission.payout = payout;
        submission.url = url;
        submission.rating = 0;
        submission.refunded = false;
        submission.time = now;

        submissions[tx.origin] = submission;
        subAddresses.push(tx.origin);
    }

    function rate(address _submitter, uint256 rating) onlyOwner
    {
        require(closed == false);
        require(now > endTime);
        require(now < refundTime);

        submissions[_submitter].rating = rating;
    }

    function pay(address _submitter) onlyOwner payable {
        require(closed == true);
        require(submissions[_submitter].owner != 0x0);

        bounty = bounty.sub(msg.value);

        _submitter.transfer(msg.value);

    }

    function close(address _winner, uint256 _totalRating) onlyOwner
    {
        require(closed == false);

        winner = _winner;
        totalRating = _totalRating;

        closed = true;
    }

    function refund()
    {
        require(submissions[tx.origin].owner == tx.origin);
        require(submissions[tx.origin].refunded == false);
        require(now > refundTime);
        require(closed = false);

        submissions[tx.origin].refunded = true;
        collectedFees = collectedFees.sub(entryFee);
        tx.origin.transfer(entryFee);
    }

    function getStart() external constant returns (uint256) {
        return startTime;
    }

    function getEnd() external constant returns (uint256) {
        return endTime;
    }

    function getRefundTime() external constant returns (uint256) {
        return refundTime;
    }

    function getSubmitter() external constant returns (address) {
        return submissions[tx.origin].owner;
    }

    function getRating(address _submitter) external constant returns (uint256) {
        return submissions[_submitter].rating;
    }

    function getTotalRating() external constant returns (uint256) {
        return totalRating;
    }
}
