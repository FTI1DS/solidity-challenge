// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

contract ETHPool {
    struct User {
        uint deposits;
        uint rewards;
    }
    mapping(address => User) public users; 
    address public team;
    address[] public allUsers;
    uint public totalDeposits;
    uint public totalRewards;
    
    event Deposit(address indexed user, uint amount);
    event RewardDeposit(uint timestamp, uint amount);
    event Withdraw(address indexed user, uint amount);

    constructor() {
        team = msg.sender;
    }

    modifier onlyTeam() {
        require(msg.sender == team, "Only team can call this function");
        _;
}
    // user-deposit
    function deposit() external payable {
        require(msg.value > 0, "Please enter an amount greater than 0");
        if (users[msg.sender].deposits == 0){
            allUsers.push(msg.sender);
        }    
        users[msg.sender].deposits += msg.value;
        totalDeposits += msg.value;
        
        emit Deposit (msg.sender, msg.value);
        
    }

    // user-withdraw of given amount
    function withdraw(uint _amount) external {
        require(_amount > 0, "Please enter an amount greater than 0");
        uint userDeposit = users[msg.sender].deposits;
        uint userReward = users[msg.sender].rewards;
        require(_amount <= (userDeposit+userReward), "Withdraw amount exceeds balance");
        if (_amount <= userDeposit){
            users[msg.sender].deposits -= _amount;
            payable(msg.sender).transfer(_amount);
            totalDeposits -= _amount;
        } else{
            uint diff = _amount - userDeposit;
            users[msg.sender].deposits = 0;
            users[msg.sender].rewards -= diff;
            payable(msg.sender).transfer(_amount);
            totalDeposits -= userDeposit;
            totalRewards -= diff;
        }
    }

    //rewardDeposit of the Team; will be split on the percentage of current lp-holders
    function rewardDeposit()  external payable onlyTeam {
        require(msg.value > 0, "Please enter an amount greater than 0");
        require(totalDeposits > 0, "No deposits");
        for(uint i=0;i<allUsers.length;i++){
            address user = allUsers[i];
            uint userDeposit = users[user].deposits;
            uint userReward = users[user].rewards;
            uint UserTotal = userDeposit + userReward;
            uint reward = msg.value * UserTotal / (totalDeposits+totalRewards);
            users[user].rewards += reward;

        }
        totalRewards += msg.value;
        emit RewardDeposit(block.timestamp, msg.value);
    }

    //return the actual deposit of a given User
    function getUserDeposit(address _user) external view returns (uint){
        return users[_user].deposits;
    }

    //return the actual reward of a given User
    function getUserReward(address _user) external view returns (uint){
        return users[_user].rewards;
    }

}