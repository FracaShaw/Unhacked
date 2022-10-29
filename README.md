# To deploy the contracts and create a settlement on local machine run in two terminals:
terminal 0: anvil
terminal 1: forge script script/Deploy.s.sol:Deploy --fork-url http://localhost:8545 -vvv
