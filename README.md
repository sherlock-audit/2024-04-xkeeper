
# xKeeper contest details

- Join [Sherlock Discord](https://discord.gg/MABEWyASkp)
- Submit findings using the issue page in your private contest repo (label issues as med or high)
- [Read for more details](https://docs.sherlock.xyz/audits/watsons)

# Q&A

### Q: On what chains are the smart contracts going to be deployed?
Any EVM-compatible network. Beta version already deployed on Optimism Mainnet and Ethereum Mainnet
___

### Q: If you are integrating tokens, are you allowing only whitelisted tokens to work with the codebase or any complying with the standard? Are they assumed to have certain properties, e.g. be non-reentrant? Are there any types of <a href="https://github.com/d-xo/weird-erc20" target="_blank" rel="noopener noreferrer">weird tokens</a> you want to integrate?
Any ERC20 token could be added into the AutomationVault, and any relay could be built to accept that ERC20 as form of payment. The system is completely modular.
___

### Q: Are the admins of the protocols your contracts integrate with (if any) TRUSTED or RESTRICTED? If these integrations are trusted, should auditors also assume they are always responsive, for example, are oracles trusted to provide non-stale information, or VRF providers to respond within a designated timeframe?
Each approved relay by an automation vault has the capability of withdrawing all the vault deposited funds.

In the case of the GelatoRelay, because of how Gelato works, their bots are trusted and have the possibility, if malicious, to steal the vault funds. So yes, Gelato is TRUSTED.

As for the other protocol integrations, there is no relevance to protocol admins, so everything else is RESTRICTED.
___

### Q: Are there any protocol roles? Please list them and provide whether they are TRUSTED or RESTRICTED, or provide a more comprehensive description of what a role can and can't do/impact.
Each automation vault has an owner, that role is RESTRICTED.
___

### Q: For permissioned functions, please list all checks and requirements that will be made before calling the function.
AutomationVault
- changeOwner: Only the current owner can set a new pending owner.
- acceptOwner: Only the pending owner can accept ownership, finalizing the transfer.
- withdrawFunds: Only the owner can withdraw funds (native or ERC20 tokens) to a specified address.
- addRelay, deleteRelay, modifyRelay, modifyRelayCallers, and modifyRelayJobs: Only the owner can manage relays and their associated jobs and callers.
- exec: Validates that the caller is approved for the relay and the job selector is authorized before executing jobs and processing payments.

XKeeperMetadata
- setAutomationVaultMetadata: It checks if the caller (msg.sender) is the owner of the AutomationVault before allowing metadata updates.

Keep3rRelay
- exec: Only valid keepers can execute automation tasks. It checks if the caller (msg.sender) is a registered keeper with KEEP3R_V2.isKeeper.

Keep3rBondedRelay
- setAutomationVaultRequirements: The caller must be the owner of the AutomationVault for which the requirements are being set. This ensures that only the vault owner can define or update the bond requirements.
- exec: The caller (keeper) must meet the bond requirements specified for the AutomationVault. These requirements can include a specific bond token, a minimum bond amount, earnings thresholds, and age (time since becoming a keeper). This ensures that only keepers who meet these predefined criteria can execute jobs.  Also this function checks if the caller (msg.sender) is a valid bonded keeper according to the KEEP3R_V2.isBondedKeeper method. This method assesses the caller against the bond requirements set for the AutomationVault, including the type of bond, minimum bond amount, earned credits, and keeper age.
___

### Q: Is the codebase expected to comply with any EIPs? Can there be/are there any deviations from the specification?
No.
___

### Q: Are there any off-chain mechanisms or off-chain procedures for the protocol (keeper bots, arbitrage bots, etc.)?
Each relay can require different types of keeper bots. However, this is out of scope of xKeeper since it is a completely modular and permissionless system.
___

### Q: Are there any hardcoded values that you intend to change before (some) deployments?
xKeeper defines specific instances of The Keep3r Network and Gelato Automate contracts for each chain. These contract addresses are hardcoded in the deployment scripts, and may change depending on the deployment chain or upgrades of the external service.
___

### Q: If the codebase is to be deployed on an L2, what should be the behavior of the protocol in case of sequencer issues (if applicable)? Should Sherlock assume that the Sequencer won't misbehave, including going offline?
Sherlock should not assume that the Sequencer won't misbehave.

Nevertheless, we are aware that if the Sequencer experiences downtime, naturally scheduled tasks within the Automation Vault that require timely execution might be delayed.

___

### Q: Should potential issues, like broken assumptions about function behavior, be reported if they could pose risks in future integrations, even if they might not be an issue in the context of the scope? If yes, can you elaborate on properties/invariants that should hold?
Yes.
___

### Q: Please discuss any design choices you made.
In designing our Automation Vault, we chose to accept payments in any ERC20 token for flexibility. However, Open Relay and Gelato Relay are currently set to only accept ETH due to its easy payment calculation. On the other hand, the Keep3r Relay uses its KP3R credits system, aligning with its specific ecosystem needs.

These choices reflect a balance between operational efficiency and user convenience within each relay's context. We're open to adapting these payment protocols based on protocols feedback and evolving integration requirements.
___

### Q: Please list any known issues/acceptable risks that should not result in a valid finding.
We assume that Gelato is in charge of calculating the payout in the Gelato Relay and therefore, if gelato becomes malicious, it could extract the entire balance from the automation vault that has passed the Gelato Relay.

For both the OpenRelay and the Keep3rRelay, the priority fee of the keeper is not taken into account by design. Keepers paying high priority fee is disincentivized.
___

### Q: We will report issues where the core protocol functionality is inaccessible for at least 7 days. Would you like to override this value?
-
___

### Q: Please provide links to previous audits (if any).
-
___

### Q: Please list any relevant protocol resources.
https://xkeeper.network/
https://docs.xkeeper.network/
___

### Q: Additional audit information.
-
___



# Audit scope


[xkeeper-core @ 615834b896f9d2067a90477612c3e7fbb71cd323](https://github.com/defi-wonderland/xkeeper-core/tree/615834b896f9d2067a90477612c3e7fbb71cd323)
- [xkeeper-core/solidity/contracts/core/AutomationVault.sol](xkeeper-core/solidity/contracts/core/AutomationVault.sol)
- [xkeeper-core/solidity/contracts/core/AutomationVaultFactory.sol](xkeeper-core/solidity/contracts/core/AutomationVaultFactory.sol)
- [xkeeper-core/solidity/contracts/periphery/XKeeperMetadata.sol](xkeeper-core/solidity/contracts/periphery/XKeeperMetadata.sol)
- [xkeeper-core/solidity/contracts/relays/GelatoRelay.sol](xkeeper-core/solidity/contracts/relays/GelatoRelay.sol)
- [xkeeper-core/solidity/contracts/relays/Keep3rBondedRelay.sol](xkeeper-core/solidity/contracts/relays/Keep3rBondedRelay.sol)
- [xkeeper-core/solidity/contracts/relays/Keep3rRelay.sol](xkeeper-core/solidity/contracts/relays/Keep3rRelay.sol)
- [xkeeper-core/solidity/contracts/relays/OpenRelay.sol](xkeeper-core/solidity/contracts/relays/OpenRelay.sol)
- [xkeeper-core/solidity/utils/Constants.sol](xkeeper-core/solidity/utils/Constants.sol)


