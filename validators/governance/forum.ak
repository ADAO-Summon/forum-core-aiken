use aiken/collection/list
use aiken/collection/pairs
use cardano/address.{Credential}
use cardano/assets.{AssetName, PolicyId}
use cardano/transaction.{OutputReference, Redeemer, ScriptPurpose, Transaction}
use common/utils.{check_withdraw_redeemer, find_utxo_with_nft, get_inline_data}

// Forum: Where Mere Assembly Gives Way to Governance

pub type ForumConfig = Data

// These are parameters that should be used by the different scripts.

pub type ForumDatum {
  Forum(ForumConfig, Data)
  Stake(Data)
  Proposal(Data)
  Execution(ByteArray, Data)
}

pub type ForumRedeemer {
  UpdateGovernance(ForumDatum)
  TakeAction(Data)
}

/// Forum works as a proxy for the proposal, stake, and execution scripts.
/// It remains highly flexible for different governance mechanisms.
/// Stake logic is hard-coded to prevent users from facing changing behavior for their assets.
validator forum(
  // Forum Parameters / These are script hashes.
  forum_logic: ByteArray,
  stake_logic: ByteArray,
  proposal_logic: ByteArray,
  execution_logic: ByteArray,
  // The state thread for the forum
  forum_policy: PolicyId,
  forum_name: AssetName,
) {
  spend(
    d: Option<ForumDatum>,
    r: ForumRedeemer,
    out_ref: OutputReference,
    tx: Transaction,
  ) {
    let Transaction { redeemers, .. } = tx
    when d is {
      Some(our_datum) -> {
        // First we find the element containing our control NFT.
        let input = find_utxo_with_nft(forum_policy, forum_name, tx)

        when (our_datum, r) is {
          (Forum(_, _), UpdateGovernance(new_forum_datum)) ->
            // Update Governance
            // Here we enforce that there is a burnt execution token
            todo
          (Forum(_, forum_data), TakeAction(forum_action)) ->
            // Forum Action
            check_withdraw_redeemer(redeemers, forum_logic, (forum_data, forum_action))
          (Stake(stake_data), TakeAction(stake_action)) ->
            // Move Stake
            check_withdraw_redeemer(redeemers, stake_logic, (stake_data, stake_action))
          (Proposal(proposal_data), TakeAction(proposal_action)) ->
            // Vote Proposal, Vote Proposal Order, Vote Batch, and Advance Proposal
            check_withdraw_redeemer(
              redeemers,
              proposal_logic,
              (proposal_data, proposal_action),
            )
          (Execution(execution_hash, execution_data), TakeAction(_)) ->
            // Execute Proposal
            check_withdraw_redeemer(redeemers, execution_hash, execution_data)
          _ -> fail
        }
      }
      _ ->
        // Custom logic can be added to the forum with or without datum.
        check_withdraw_redeemer(redeemers, forum_logic, None)
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
