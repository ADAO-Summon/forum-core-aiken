use aiken/collection/list
use aiken/collection/pairs
use cardano/address.{Credential}
use cardano/assets.{AssetName, PolicyId}
use cardano/transaction.{OutputReference, Transaction}
use common/utils.{get_inline_data}

// Forum: Where Mere Assembly Gives Way to Governance

pub type ForumDatum {
  Forum(
    // Execution Logic
    ByteArray,
    // Proposal Logic
    ByteArray,
    // Extra Data
    Data
    )
  Stake(Data)
  Proposal(Data)
  Execution(Data) // This must contain the execution logic and appropriate data.
}

pub type GovHubRedeemer {
    UpdateGovernance(ForumDatum)
    Other(Data)
}

/// Forum works as a proxy for the proposal and execution policies.
/// It remains highly flexible for different governance mechanisms.
/// Stake logic is hard-coded to prevent users from facing changing behavior for their assets.
validator forum(
  forum_logic: Credential,
  stake_logic: Option<Credential>,
  forum_policy: PolicyId,
  forum_name: AssetName,
) {
  spend(d: Option<ForumDatum>, r: GovHubRedeemer, out_ref: OutputReference, tx: Transaction) {
    expect Some(our_datum) = d

    // First we find the element containing our NFT.
    let Transaction { reference_inputs, inputs, withdrawals, .. } = tx
    let maybe_ref =
      list.find(
        reference_inputs,
        fn(i) {
          assets.quantity_of(i.output.value, forum_policy, forum_name) == 1
        },
      )
    let input =
      when maybe_ref is {
        Some(ref_input) -> ref_input
        None -> {
          expect Some(input) =
            list.find(
              inputs,
              fn(i) {
                assets.quantity_of(i.output.value, forum_policy, forum_name) == 1
              },
            )
          input
        }
      }
    expect control_datum: ForumDatum = get_inline_data(input.output.datum)

    when (our_datum, r) is {
      (Forum(_, _, _), UpdateGovernance(new_forum_datum)) -> { //
        // Here we enforce that there is a burnt execution token and the appropriate stake logic executes.
        todo
      }
      (Forum(_, _, other_data), Other(_)) -> {
        // Here we enforce that the forum logic executes.
        todo
      }
      (Stake(stake_data), Other(_)) -> {
        // Here we enforce that the stake logic executes.
        todo
      }
      (Proposal(proposal_data), Other(_)) -> {
        // Here we enforce that the proposal logic executes.
        todo
      }
      (Execution(execution_data), Other(_)) -> {
        // Here we enforce that the execution logic executes.
        todo
      }
      _ -> {
        fail
      }
    }
  }

  else(_) {
    fail
  }
}
