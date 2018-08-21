pragma solidity ^0.4.24;

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
	address owner = msg.sender;
	uint size;
	uint a;

	function addUsr(uint _id, address _addr, uint _age, string _name,
		string _alias, string _surname) public {
		require(msg.sender == owner, "You are not authorized!");
		require(isUnique(_addr, _id) == 1, "This user is already registered");
		size++;
		authorizedUsers.push(User(_id, _addr, _age, _name, _alias, _surname));
	}

	function isUnique(address addr, uint id) private returns (int ret) {
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

	mapping (address => Cand) votes;
	mapping (address => address) voters;
	address owner = msg.sender;
	uint winner;

	function addCandidate(address _addr) public {
		require(msg.sender == owner, "You are not authorized!");
		require(isActiveCand(_addr) == 0,
			"The candidate is already in the list");
		votes[_addr]._active = true;
	}

	function removeCandidate(address _addr) public {
		require(msg.sender == owner, "You are not authorized!");
		require(isActiveCand(_addr) == 1, "The candidate is already removed");
		votes[_addr]._active = false;
	}

	function isActiveCand(address name) view public returns (int ret) {
		if (votes[name]._active == true)
			return (1);
		return (0);
	}

	function checkWinner() view public returns (uint) {
		require(winner > 0,
			"The election is still active, please try again later");
		return (winner);
	}
}
