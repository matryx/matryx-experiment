pragma solidity ^0.4.13;

import './math/SafeMath.sol';

/**
 */
contract MatryxRound
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

    address owner;
    bool closed;

    uint256 bounty;
    uint256 entryFee;

    MatryxSubmission[] public submissions;

    uint256 startTime;
    uint256 endTime;
    uint256 refundTime;
    uint256 roundNumber;

    function MatryxRound(uint256 _start, uint256 _end, uint256 _refund, uint256 _entryFee, uint256 _roundNumber)
    {
        owner = msg.sender;
        bounty = msg.value;
        entryFee = _entryFee;

        require(entryFee > 0);
        require(bounty > 0);

        startTime = _start;
        endTime = _end;
        refundTime = _refund;
        roundNumber = _roundNumber;

        require(startTime > now);
        require(startTime < endTime);
        require(refundTime > endTime);

        closed = false;
    }

    function submit(bytes url, address payout) payable
    {
        require(closed == false);
        require(now > startTime);
        require(now < endTime);
        require(msg.value >= entryFee);

        MatryxSubmission memory submission;
        submission.owner = msg.sender;
        submission.payout = payout;
        submission.url = url;
        submission.rating = 0;
        submission.refunded = false;
        submission.time = now;
        submissions.push(submission);
    }

    function rate(uint256 submissionIdx, uint256 rating)
    {
        require(closed == false);
        require(now > endTime);
        require(now < refundTime);
        require(msg.sender == owner);

        require(submissionIdx < submissions.length);
        submissions[submissionIdx].rating = rating;
    }

    function close()
    {
        require(closed == false);
        require(now > endTime);
        require(now < refundTime);
        require(msg.sender == owner);

        uint256 i = 0;
        uint256 totalRating = 0;

        for (i = 0; i < submissions.length; i++)
        {
            if (submissions[i].rating > 0)
            {
                totalRating = totalRating.add(submissions[i].rating);
            }
        }

        require(totalRating > 0);

        for (i = 0; i < submissions.length; i++)
        {
            // Payout fair share to submission
            // Compensation == Bounty * TotalRating / SubmissionRating
            if (submissions[i].rating > 0)
            {
                uint256 compensation = bounty.mul(totalRating).div(submissions[i].rating);
                // Send compasation to "submissions[i].payout"
            }
        }
        closed = true;
    }

    function refund(uint256 submissionIdx)
    {
        require(closed == false);
        require(now > refundTime);

        require(submissionIdx < submissions.length);
        require(msg.sender == submissions[submissionIdx].owner);
        require(submissions[submissionIdx].refunded == false);

        // Refund msg.sender of the "fee" + fair share of the bounty
        uint256 compensation = bounty.div(submissions.length).add(entryFee);
        // Send compensation to "submissions[submissionIdx].payout"
        submissions[submissionIdx].refunded = true;
    }

}
