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
	address owner = msg.sender;
	uint size;
	uint a;
	string public rools = "Only those users who reached 18 years can be authorized * You should be the owner in order to authorize users and kill the contract * You can check the users who was authorized earlier using the public list";

	function getAuth(address addr) public returns (bool) {
		a = 0;
		while (a < size) {
			if (authorizedUsers[a]._addr == addr)
				return (true);
			a++;
		}
		return (false);
	}

	function killContract() public {
		if (msg.sender == owner)
			selfdestruct(owner);
	}

	function addUsr(address _addr, uint _age, string _name,
		string _alias, string _surname) public {
		require(msg.sender == owner);
		require(_age >= 18);
		require(isUnique(_addr) == 1);
		authorizedUsers.push(User(size, _addr, _age, _name, _alias, _surname));
		size++;
	}

	function isUnique(address addr) private returns (int ret) {
		a = 0;

		while (a < size) {
			if (authorizedUsers[a]._addr == addr)
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

	address owner = msg.sender;
	address passAddr;
	mapping (address => Cand) votes;
	mapping (address => Vote) voters;
	address[] validVotes;
	uint maxvotes;
	address winner;
	uint totalvotes;
	bool end;
	bool error;
	uint i;
	string public rools = "You should be the owner in order to add and remove candidates, stop voting and kill the contract * You should be registered via Passport in order to vote * You can vote only once * Before voting, it is recommended to check whether your candidate is active * You can vote for yourself * You can check the winner when the voting is over";
	string public whoIsTheWinner = "Voting is still active. To check the winner, please wait until voting is over.";

	function Election(address _passAddr) public {
		require(_passAddr != 0);
		passAddr = _passAddr;
		error = true;
	}

	function check(address userAddr) private returns (bool) {
		Passport x = Passport (passAddr);
		return x.getAuth(userAddr);
	}

	function vote (address _vote) public {
		require(check(msg.sender) == true);
		require(voters[msg.sender]._voted == false);
		require(votes[_vote]._active == true);
		voters[msg.sender]._voted = true;
		voters[msg.sender]._cand = _vote;
		votes[_vote]._votes += 1;
		validVotes.push(_vote);
		totalvotes += 1;
	}

	function killContract() public {
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
		if (error == true)
			whoIsTheWinner = "The voting is over but there is no winner :(";
		else
			whoIsTheWinner = "The voting is over. Check the winner by calling the respective function";
	}

	function checkWinner() view public returns (address) {
		require(end == true);
		require(error == false);
		return (winner);
	}
}
