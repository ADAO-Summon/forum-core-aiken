use cardano/transaction.{Transaction}
use cardano/assets.{AssetName}

pub type VoteDirectRedeemer = (ByteArray, ProposalVote)

pub type ExecutionDatum {
  execution_script: ByteArray,
  execution_args: List<Data>,
}

pub type ProposalState {
  outcomes_with_vote: List<(Int, ExecutionDatum)>, 
  vote_expiry_time: Int
}

pub type ProposalDatum {
  Order(ProposalVote)
  Voting(ProposalState)
  ExecutionReady
}

pub type ProposalVote {
  outcome: Int,
  proposal: ProposalDatum,
  proposal_name: AssetName,
  // stake: AssetName, // The stake thread being used to vote.
}

validator action {
  withdraw((forum_hash, vote_info): VoteDirectRedeemer, _c, tx: Transaction) {
    todo
  }

  else(_) {
    fail
  }
}