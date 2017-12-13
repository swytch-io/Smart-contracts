pragma solidity ^0.4.11;

contract token { function transfer(address receiver, uint amount);
function transferFrom(
         address _from,
         address _to,
         uint256 _amount
     ) returns (bool success) ;
     function approve(address _spender, uint256 _amount) returns (bool success);
     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
                }

contract CrowdSale {
    enum State {
        Fundraising,
        Failed,
        Successful,
        Closed
    }
    State public state = State.Fundraising;

    struct Contribution {
        uint amount;
        address contributor;
    }
    Contribution[] contributions;

    
    
    uint public totalRaised;
    uint public currentBalance;
    uint public deadline;
    uint public completedAt;
    uint public priceInWei;
    uint public fundingMinimumTargetInWei; 
    uint public fundingMaximumTargetInWei; 
    token public tokenReward;
    address public creator;
    address public beneficiary; 
    string campaignUrl;
    //byte constant version = 1;

    
    event LogFundingReceived(address addr, uint amount, uint currentTotal);
    event LogWinnerPaid(address winnerAddress);
    event LogFundingSuccessful(uint totalRaised);
    event LogFunderInitialized(
        address creator,
        address beneficiary,
        string url,
        uint _fundingMaximumTargetInEther, 
        uint256 deadline);


    modifier inState(State _state) {
        require(state == _state);
        // if (state != _state) throw;
         _;
    }

     modifier isMinimum() {
        require(msg.value >= priceInWei);
        // if(msg.value < priceInWei) throw;
        _;
    }

    modifier inMultipleOfPrice() {
        require(msg.value%priceInWei == 0);
        // if(msg.value%priceInWei != 0) throw;
        _;
    }

    modifier isCreator() {
        require(msg.sender == creator);
        // if (msg.sender != creator) throw;
        _;
    }

    
    modifier atEndOfLifecycle() {
        // if(!((state == State.Failed || state == State.Successful) && completedAt + 1 hours < now)) {
        //     throw;
        // }
        require((state == State.Failed || state == State.Successful) && completedAt + 1 hours < now);
        _;
    }

    
    function CrowdSale(
        uint _deadline,
        string _campaignUrl,
        address _fundraiser,
        uint _softCap,
        uint _hardCap,
        token _rewardtoken,
        uint _etherCostOfEachToken)
    {
        creator = msg.sender;
        beneficiary = _fundraiser;
        campaignUrl = _campaignUrl;
        fundingMinimumTargetInWei = _softCap * 1 ether; 
        fundingMaximumTargetInWei = _hardCap * 1 ether; 
        deadline = now + (_deadline * 1 minutes);
        currentBalance = 0;
        tokenReward = token(_rewardtoken);
        priceInWei = _etherCostOfEachToken * 1 ether;
        LogFunderInitialized(
            creator,
            beneficiary,
            campaignUrl,
            fundingMaximumTargetInWei,
            deadline);
    }

    function contribute()
    public
    inState(State.Fundraising) isMinimum() inMultipleOfPrice() payable returns (uint256)
    {
        uint256 amountInWei = msg.value;

        
        contributions.push(
            Contribution({
                amount: msg.value,
                contributor: msg.sender
                }) 
            );

        totalRaised += msg.value;
        currentBalance = totalRaised;


        //if(fundingMaximumTargetInWei != 0) {
            
            tokenReward.transfer(msg.sender, amountInWei / priceInWei);
        //}
       /* else{
            tokenReward.mintToken(msg.sender, amountInWei / priceInWei);
        }*/

        LogFundingReceived(msg.sender, msg.value, totalRaised);
        checkIfFundingCompleteOrExpired();
        return contributions.length - 1; 
    }

    function checkIfFundingCompleteOrExpired() internal{
        
       
        if (fundingMaximumTargetInWei != 0 && totalRaised > fundingMaximumTargetInWei) {
            state = State.Successful;
            LogFundingSuccessful(totalRaised);
            payOut();
            completedAt = now;
            
            } else if ( now > deadline )  {
                if(totalRaised >= fundingMinimumTargetInWei){
                    state = State.Successful;
                    LogFundingSuccessful(totalRaised);
                    payOut();  
                    completedAt = now;
                }
                else{
                    state = State.Failed; 
                    completedAt = now;
                }
            } 
        
    }

        function payOut()
        
        inState(State.Successful)
        {
            
            // if(!beneficiary.send(this.balance)) {
            //     throw;
            // }
            require(beneficiary.send(this.balance));
            state = State.Closed;
            currentBalance = 0;
            LogWinnerPaid(beneficiary);
        }

        function getRefund()
        public
        inState(State.Failed) 
        returns (bool)
        {
            for(uint i=0; i<=contributions.length; i++)
            {
                if(contributions[i].contributor == msg.sender){
                    uint amountToRefund = contributions[i].amount;
                    contributions[i].amount = 0;
                    if(!contributions[i].contributor.send(amountToRefund)) {
                        contributions[i].amount = amountToRefund;
                        return false;
                    }
                    else{
                        totalRaised -= amountToRefund;
                        currentBalance = totalRaised;
                    }
                    return true;
                }
            }
            return false;
        }

        function removeContract()
        internal
        isCreator()
        atEndOfLifecycle()
        {
            selfdestruct(msg.sender);
            
        }

        function () { revert(); }
}
