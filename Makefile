# Makefile for Foundry project

# Load environment variables from .env file
include .env
export $(shell sed 's/=.*//' .env)

.PHONY: anvil build clean coverage deploy fork_testnet fork_mainnet forked_test format fund help install snapshot test verify

# Generate Keys
anvil :
	anvil -m 'test test test test test test test test test test test junk' --steps-tracing --block-time 1 

# Build contracts
build:
	forge build

# Clean the environment
clean:
	forge clean

# Test Coverage
coverage:
	forge coverage --report debug > coverage-report.md
	
# Deploy contract
# Use ARGS="--network ONE_OF_THE_OPTIONS_IN_THE_END_OF_THE_FILE" after the request on the terminal.
deploy:
	@forge script script/Deploy.s.sol:DeployScript $(NETWORK_ARGS)

# Initialize forked network with anvil
fork_mainnet:
	anvil --fork-url ${BASE_MAINNET_RPC}

fork_testnet:
	anvil --fork-url ${BASE_SEPOLIA_RPC}

# Execute Forked tests
forked_test:
	forge test --match-contract DiamondForked.t.sol -vvv

format:
	forge fmt

# Install Dependencies
install:
	forge install foundry-rs/forge-std --no-commit && forge install openzeppelin/openzeppelin-contracts --no-commit && forge install smartcontractkit/chainlink-brownie-contracts --no-commit && forge install Uniswap/v3-core --no-commit && Uniswap/v3-periphery --no-commit && forge install Uniswap/swap-router-contracts --no-commit

# Remove modules
remove :
	rm -rf .gitmodules && rm -rf .git/modules/* && rm -rf lib && touch .gitmodules && git add . && git commit -m "modules"

# Gas Snapshot
snapshot:
	forge snapshot

# Execute tests
test:
	forge test

# Update Dependencies
update:
	forge update

NETWORK_ARGS := --rpc-url http://localhost:8545 --account ANVIL_TEST --broadcast -vvv

# Change Args if is sepolia - Update according to your needs
# Update --account $(live_burner) with your foundry encrypted key.
ifeq ($(findstring --network base-sepolia,$(ARGS)),--network base-sepolia)
	NETWORK_ARGS := --rpc-url ${BASE_SEPOLIA_RPC} --account live_burner --broadcast --verify --etherscan-api-key ${ETHERSCAN_API_KEY} -vvvvv
endif

ifeq ($(findstring --network sepolia,$(ARGS)),--network sepolia)
	NETWORK_ARGS := --rpc-url ${SEPOLIA_RPC_URL} --account live_burner --broadcast --verify --etherscan-api-key ${ETHERSCAN_API_KEY} -vvvvv
endif