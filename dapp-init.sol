pragma solidity ^0.4.20;

contract Passport {

	struct User {
		uint	_id;
		address	_addr;
		uint	_age;
		string	_name;
		string	_alias;
		string	_surname;
	}

	User[] public authorizedUsers;
	address owner;
	uint size;
	uint a;

	function() public {
		owner = msg.sender;
	}

	function kill() public {
		if (msg.sender == owner)
			selfdestruct(owner);
	}

	function addUsr(uint _id, address _addr, uint _age, string _name,
		string _alias, string _surname) public {
		require(msg.sender == owner);
		require(isUnique(_addr, _id) == 1);
		size++;
		authorizedUsers.push(User(_id, _addr, _age, _name, _alias, _surname));
	}

	function isUnique(address addr, uint id) public returns (int ret) {
		a = 0;

		while (a < size) {
			if (authorizedUsers[a]._addr == addr ||
				authorizedUsers[a]._id == id)
				return (-1);
			a++;
		}
		return (1);
	}
}

contract Election {

	struct Cand {
		bool	_active;
		uint	_votes;
	}

	struct Vote {
		address	_cand;
		bool	_voted;
	}

	address owner;
	mapping (address => Cand) votes;
	mapping (address => Vote) voters;
	address[] validVotes;
	uint maxvotes;
	address winner;
	uint totalvotes;
	bool end;
	bool error;
	uint i;

	function() public {
		owner = msg.sender;
		error = true;
	}

	function vote (address _vote) public {
		require(msg.sender != _vote);
		require(voters[msg.sender]._voted == false);
		require(votes[_vote]._active == true);
		voters[msg.sender]._voted = true;
		voters[msg.sender]._cand = _vote;
		votes[_vote]._votes += 1;
		validVotes.push(_vote);
		totalvotes += 1;
	}

	function kill() public {
		if (msg.sender == owner)
			selfdestruct(owner);
	}

	function addCandidate(address _addr) public {
		require(msg.sender == owner);
		require(isActiveCand(_addr) == false);
		votes[_addr]._active = true;
	}

	function removeCandidate(address _addr) public {
		require(msg.sender == owner);
		require(isActiveCand(_addr) == true);
		votes[_addr]._active = false;
	}

	function isActiveCand(address name) view public returns (bool isActive) {
		if (votes[name]._active == true)
			return (true);
		return (false);
	}

	function stopVoting() public {
		require(msg.sender == owner);
		require(end == false);
		end = true;
		while (i < totalvotes) {
			if (votes[validVotes[i]]._votes > maxvotes)
			{
				maxvotes = votes[validVotes[i]]._votes;
				winner = validVotes[i];
				error = false;
			}
			else if (votes[validVotes[i]]._votes == maxvotes &&
				winner != validVotes[i]) {
				error = true;
			}
			i++;
		}
	}

	function checkWinner() view public returns (address) {
//		require(isUnique(msg.sender, 0) == 1, "You are not authorized!");
		require(end == true);
		require(error == false);
		return (winner);
	}
/*
	function isUnique(address addr, uint id) public returns (int ret) {
		Passport passport = Passport(owner);
		return(passport.isUnique(addr, id));
	}
*/
}
