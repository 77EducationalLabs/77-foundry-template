//SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

///@notice Foundry Stuff
import { console } from "forge-std/console.sol";

///@notice Scripts
import { DeployScript } from "script/Deploy.s.sol";

///@notice Test Helpers
import { BaseTests } from "./BaseTests.t.sol";

///@notice Protocol contracts

/**
    *@notice Environment for Forked Tests
    *@dev it inherits the BaseTests so you don't need to declare all it again
    *@notice overrides the setUp function
*/
contract ForkedHelper is BaseTests {

    ///@notice recover the RPC_URLs from the .env file
    string BASE_SEP_RPC_URL = vm.envString("BASE_SEP_RPC_URL");

    ///@notice variable store each forked chain
    uint256 baseSepolia;

    ///@notice always use CONSTANTS instead of Magic Numbers> Like this ones: 
    uint24 constant USDC_WETH_POOL_FEE = 500; //0.05% - Uniswap Variables
    uint256 constant USDC_INITIAL_BALANCE = 10_000*10**6; // Token Amounts

    function setUp() public override {
        ///@notice Create Forked Environment
        baseSepolia = vm.createFork(BASE_SEP_RPC_URL);
        
        ///@notice to select the fork we will use. You can change between them on tests
        vm.selectFork(baseSepolia);

        ///@notice deploys the Scripts
        s_deploy = new DeployScript();

        ///@notice get the deployed 
        (s_helperConfig) = s_deploy.run();
    }
}