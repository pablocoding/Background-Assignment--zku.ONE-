// SPDX-License-Identifier: GPL-3.0
// author: Juan Pablo Ibarbo Herrera
pragma solidity >=0.7.0 <0.9.0;

contract ImprovedContract {

//  this time I use bytes32 in order to save more gas, with the help a
//  library called "ethers".
//  with this library I can take a normal string and convert it into bytes32 character and
//  vice versa bytes32 to string.
//  
//   for example, let's see the candidates:
//    
//   [0] paul: 0x7061756c00000000000000000000000000000000000000000000000000000000
//   [1] eve:  0x6576650000000000000000000000000000000000000000000000000000000000
// 
// final array: ["0x7061756c00000000000000000000000000000000000000000000000000000000","0x6576650000000000000000000000000000000000000000000000000000000000"]

// another idea was to change store for memory in other to save gas 
    
    struct Voter {
        uint weight; 
        bool voted;  
        address delegate; 
        uint vote;   
    }

    
    struct Proposal {
        bytes32 name;   
        uint voteCount; 
    }

    address public chairperson;


    mapping(address => Voter) public voters;

    
    Proposal[] public proposals;

    
    constructor(bytes32[] memory proposalNames) { 
        chairperson = msg.sender;
        voters[chairperson].weight = 1;


        for (uint i = 0; i < proposalNames.length; i++) {

            proposals.push(Proposal({
                name: proposalNames[i],
                voteCount: 0
            }));
        }
    }


    function giveRightToVote(address voter) external {

        require(
            msg.sender == chairperson,
            "Only chairperson can give right to vote."
        );
        require(
            !voters[voter].voted,
            "The voter already voted."
        );
        require(voters[voter].weight == 0);
        voters[voter].weight = 1;
    }

    
    function delegate(address to) external {
        
        Voter memory sender = voters[msg.sender]; // change store for memory in other to save gas 
        require(!sender.voted, "You already voted.");

        require(to != msg.sender, "Self-delegation is disallowed.");


        while (voters[to].delegate != address(0)) {
            to = voters[to].delegate;

            
            require(to != msg.sender, "Found loop in delegation.");
        }


        sender.voted = true;
        sender.delegate = to;
        Voter memory delegate_ = voters[to]; // change store for memory in other to save gas 
        if (delegate_.voted) {

            proposals[delegate_.vote].voteCount += sender.weight;
        } else {

            delegate_.weight += sender.weight;
        }
    }


    function vote(uint proposal) external {
        Voter memory sender = voters[msg.sender]; // change store for memory in other to save gas 
        require(sender.weight != 0, "Has no right to vote");
        require(!sender.voted, "Already voted.");
        sender.voted = true;
        sender.vote = proposal;


        proposals[proposal].voteCount += sender.weight;
    }


    function winningProposal() public view
            returns (uint winningProposal_)
    {
        uint winningVoteCount = 0;
        for (uint p = 0; p < proposals.length; p++) {
            if (proposals[p].voteCount > winningVoteCount) {
                winningVoteCount = proposals[p].voteCount;
                winningProposal_ = p;
            }
        }
    }

    function winnerName() external view
            returns (bytes32 winnerName_)
    {
        winnerName_ = proposals[winningProposal()].name;
    }
}
