# Time Keeping Payment Project

The main idea of this project is to show a mix of solidity and time mechanism. 

-----------------------------TASK---------------------------------

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------
Smart contract, which accepts payment for input, and then within 200 days makes accruals in coins at 1% of the initial amount after 200 days, the accumulated amount is returned to the participant’s balance.
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------

My opinion: It's very similar to lock token projects and staking projects. So I have chosen this mechanism of work:

ERC20 token's address is needed for deploy (as constructor argument)


Main functions: 
-------------------------

deposit() - external

User can deposit his own tokens. Input: uint256 amount

getMoney() - external

User can get all unlocked tokens. Example: User X deposited 100 tokens and 50 days are over. User X can get 25 tokens using this function.


View functions:
-------------------------

calculateReward() - internal : function for knowing unlocked tokens

getCurrentTime() - internal : block.timestamp (time now)

deposited() - external : it shows how many tokens user has deposited

percentUnlocked() - external : it shows percent of unlocked tokens of user at the moment

