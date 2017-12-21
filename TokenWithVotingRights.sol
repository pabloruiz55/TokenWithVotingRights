pragma solidity ^0.4.19;

import './ERC20Basic.sol';

contract TokenWithVotingRights is ERC20Basic {
    mapping(address => uint256) public votingRights;
    
    event TransferVotingRights(address indexed from, address indexed to, uint256 value);

    function TokenWithVotingRights() public {
        totalSupply = 100000 * 10 ** uint(decimals);
        balances[msg.sender] = totalSupply;
        votingRights[msg.sender] = totalSupply;
    }
    
    function transferTokensAndVotingRights(address _to, uint256 _value) public returns (bool) {
        require(_to != address(0));
        
        transferVotingRights(_to, _value);
        
        return(super.transfer(_to, _value));
    }
    
    function transferVotingRights(address _to, uint256 _value) public returns (bool) {
        require(_to != address(0));
        
        uint votesToTransfer = _value;
        if(_value > votingRights[msg.sender])
            votesToTransfer = votingRights[msg.sender];
    
        // SafeMath.sub will throw if there is not enough balance.
        votingRights[msg.sender] = votingRights[msg.sender].sub(votesToTransfer);
        votingRights[_to] = votingRights[_to].add(votesToTransfer);
        TransferVotingRights(msg.sender, _to, votesToTransfer);
        return true;
    }
    
    function votingRightsOf(address _owner) public view returns (uint256) {
        return ((votingRights[_owner] <= balances[_owner]) ? votingRights[_owner] : balances[_owner]);
    }
}
