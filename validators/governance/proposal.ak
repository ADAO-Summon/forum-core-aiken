use cardano/address.{Credential}
use cardano/assets.{AssetName}
use governance/execution.{ExecutionDatum}

// Proposal Names are their uniqueness.
pub type ProposalDatum {
  Order(ProposalVote)
  Voting(List<(Int, ExecutionDatum)>)
  Finished
  ExecutionReady
}

pub type ProposalVote {
  outcome: Int,
  proposal: ProposalDatum,
  proposal_name: AssetName,
  stake: AssetName,
}

pub type ProposalRedeemer {
  CreateProposal(ProposalDatum)
  Vote(ProposalVote)
  VoteOrder(ProposalVote)
  BatchVote(List<ProposalVote>)
  Advance
  Execute
}

// Basically work on the redeemer as much as possible.

validator base_proposal {
  withdraw(r: (ProposalDatum, ProposalRedeemer), _a, _c) {
    // Here we want to allow the state transition to occur.
    when r is {
      (Voting(votes), Vote(_)) -> todo // Uses stake logic
      (Voting(votes), VoteOrder(_)) -> todo // Uses stake logic / new token
      (Voting(votes), BatchVote(_)) -> todo // Merges Orders
      (Voting(votes), Advance) -> todo // Moves to Finished.
      (Voting(votes), Execute) -> todo // Burns the proposal and mints execution token(s).
      _ -> fail
    }
  }

  mint(r: Data, _p, _t) {
    // Here we handle the generation of the proposal NFT for a given proposal.
    // Ensure only a single proposal is minted, and ensure it has a unique name.
    // Ensure that the votes are initialized to 0.
    // Ensure that the proposal contains a null outcome.
    // Ensure the proposal goes back to the forum.
    todo
  }

  else(_) {
    fail
  }
}
