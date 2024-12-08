use aiken/collection/list
use aiken/collection/pairs
use cardano/address.{Credential, Script}
use cardano/assets.{AssetName, PolicyId}
use cardano/transaction.{OutputReference, Redeemer, ScriptPurpose, Transaction}
use common/utils.{check_withdraw_redeemer, find_utxo_with_nft, get_inline_data, check_proper_burn_with_policy, check_proper_burn_with_policy_and_name}

// Forum: Where Mere Assembly Gives Way to Governance

pub type ForumConfig {
  minimum_power_to_create: Int, // Minimum vote power to create a proposal.
  minimum_quorum: Int, // Minimum number of votes on and outcome to be considered valid.
  minimum_vote_size: Int // Minimum vote size.
}

pub type ForumDatum {
  Forum(ForumConfig, Data)
  Stake(Data)
  VoteOrder(Data)
  Proposal(Data)
  Execution(ByteArray, Data)
}

// The action should pass anything that is needed for the associated withdrawal script(s) to execute.
// Each action simply calls the relevant withdrawal scripts.
pub type ForumAction {
  MoveStake(Data) // Spend
  BurnStake(Data) // Spend / Mint
  VoteProposal(Data) // Spend
  VoteProposalOrder(Data) // Spend / Mint
  VoteBatchProposal(Data) // Spend / Mint
  FinishProposal(Data) // Spend / Mint
  ExecuteOutcome(Data) // Spend / Mint
  Custom(Data) // Spend / ? - ? -> Default behavior fail
}

pub type MintSpecificAction {
  CreateStake(Data)
  CreateProposal(Data)
}

pub type MintAction {
  Mint(MintSpecificAction)
  MintAndMove(ForumAction)
}

validator forum(
  forum_custom_logic: ByteArray,
  unlock_stake: ByteArray,
  vote_direct: ByteArray,
  create_vote_order: ByteArray,
  batch_votes: ByteArray,
  finish_proposal: ByteArray,
  execute_outcome: ByteArray,
  forum_policy: PolicyId,
  forum_name: AssetName,
) {
  spend(
    d: Option<ForumDatum>,
    r: ForumAction,
    out_ref: OutputReference,
    tx: Transaction,
  ) {
    let Transaction { redeemers, .. } = tx
    let input = find_utxo_with_nft(forum_policy, forum_name, tx)
    expect Script(forum_main_script) = input.output.address.payment_credential
    when d is {
      Some(our_datum) -> {
        // First we find the element containing our control NFT.
        let input = find_utxo_with_nft(forum_policy, forum_name, tx)

        when r is {
          MoveStake(passed_data) | BurnStake(passed_data) -> {
            expect Stake(_) = our_datum
            check_withdraw_redeemer(redeemers, unlock_stake, (forum_main_script, passed_data))
          }
          VoteProposal(passed_data) -> {
            let _x = when our_datum is {
              Stake(_) -> 0
              Proposal(_) -> 0
              _ -> fail
            }
            check_withdraw_redeemer(redeemers, vote_direct, (forum_main_script, passed_data))
          }
          VoteProposalOrder(passed_data) -> {
            expect Stake(_) = our_datum
            check_withdraw_redeemer(redeemers, create_vote_order, (forum_main_script, passed_data))
          }
          VoteBatchProposal(passed_data) -> {
            let _x = when our_datum is {
              VoteOrder(_) -> 0
              Proposal(_) -> 0
              _ -> fail
            }
            check_withdraw_redeemer(redeemers, batch_votes, (forum_main_script, passed_data))
          }
          FinishProposal(passed_data) -> {
            expect Proposal(_) = our_datum
            check_withdraw_redeemer(redeemers, finish_proposal, (forum_main_script, passed_data))
          }
          ExecuteOutcome(passed_data) -> {
            let _x = when our_datum is {
              Execution(_, _) -> 0
              Forum(_, _) -> 0
              _ -> fail
            }
            check_withdraw_redeemer(redeemers, execute_outcome, (forum_main_script, passed_data))
          }
          Custom(_) -> todo
        }
      }
      _ -> todo
    }
  }

  /// All minting is handled by the Forum script.
  /// We ensure uniqueness of the name, as well as the proper logic being executed.
  mint(r: MintAction, p: PolicyId, t: Transaction) {
    when r is {
      Mint(CreateStake(_)) -> {
        // Stake must have unique name, valid tokens present
        todo
      }
      MintAndMove(BurnStake(_)) -> {
        // Stake can only be removed when thread is burnt.
        // User must sign and have no valid locks.
        todo
      }
      Mint(CreateProposal(_)) -> {
        // Proposal must have unique name, valid tokens present
        // Proposal must be created with a valid state.
        todo
      }
      MintAndMove(VoteProposalOrder(_)) -> {
        // We only check to make sure that the order is valid, not that the proposal exists.
        // Based on the user stake consumed as input, lock must be applied.
        todo
      }
      MintAndMove(VoteBatchProposal(_)) -> {
        // We ensure that the orders are properly applied to the proposal state.
        // All order tokens must be burnt. (i.e. only ongoing thread is the proposal)
        todo
      }
      MintAndMove(FinishProposal(_)) -> {
        // Proposal must be finished with voting period.
        // Outcome must be the correct one.
        // Quorums must be met for the outcome.
        // Execution tokens are minted correctly, proposal is burnt.
        todo
      }
      MintAndMove(ExecuteOutcome(_)) -> {
        // Pass authority to execution script as described in the datum.
        // This allows Update to be performed explicitly.
        todo
      }
      _ -> fail
    }
  }

  else(_) {
    fail
  }
}

validator forum_logic {
  else(_) {
    fail
  }
}
