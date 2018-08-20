pragma solidity ^0.4.24;

contract Election {

	string[] candidates;
	address owner = msg.sender;
	string winner;

	function addCandidate(string _name) public {
		require(msg.sender == owner, "Sender not authorized!");
		require(isUniqueCand(_name) == 1, "This user is already registered");
		candidates.push(_name);
	}

	function isUniqueCand(string name) private returns (int ret) {
		return (1);
	}
}
