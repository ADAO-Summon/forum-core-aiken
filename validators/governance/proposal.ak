use cardano/address.{Credential}
use cardano/assets.{AssetName}

// Proposal Names are their uniqueness.
pub type ProposalDatum {
    Outcomes(List<(List<(Credential, Data)>, Int)>, Int)
    Finished(List<(Credential, Data)>)
    ExecutionReady
}

pub type ProposalVote {
    outcome: Int,
    proposal: ProposalDatum,
    proposal_name: AssetName,
    stake_name: AssetName,
}

pub type ProposalRedeemer {
    VoteDirectly(ProposalVote)
    VoteWithOrder(ProposalVote)
    Stake(Data)
    Execute
}

// Basically work on the redeemer as much as possible.

validator base_proposal {
  withdraw(r: (ProposalRedeemer, Data), _a, _c) {
    True
  }

  else(_) {
    fail
  }
}
