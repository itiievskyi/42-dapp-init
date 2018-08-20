pragma solidity ^0.4.24;

contract Passport {

	struct User {
		address _address;
		string _name;
		string _alias;
		string _surname;
	}

	User[] public authorizedUsers;
	address owner = msg.sender;
	uint size;
	uint a;

	function addUsr(address _address, string _name,
		string _alias, string _surname) public {
		require(msg.sender == owner, "Sender not authorized!");
		require(isUnique(_address) == 1, "This user is already registered");
		size++;
		authorizedUsers.push(User(_address, _name, _alias, _surname));
	}

	function isUnique(address addr) private returns (int ret) {
		a = 0;

		while (a < size) {
			if (authorizedUsers[a]._address == addr)
				return (-1);
			a++;
		}
		return (1);
	}
}
