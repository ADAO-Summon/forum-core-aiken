// [ DEPRECATED ]

// use cardano/address.{Credential}
// use cardano/assets.{AssetName}
// use governance/execution.{ExecutionDatum}

// pub type ForumConfig {
  // minimum_power_to_create: Int, // Minimum vote power to create a proposal.
  // minimum_quorum: Int, // Minimum number of votes on and outcome to be considered valid.
  // minimum_vote_size: Int // Minimum vote size.
// }

// pub type ProposalState {
  // outcomes_with_vote: List<(Int, ExecutionDatum)>, 
  // vote_expiry_time: Int
// }

// // Proposal Names are their uniqueness.
// pub type ProposalDatum {
  // Order(ProposalVote)
  // Voting(ProposalState)
  // ExecutionReady
// }

// pub type ProposalVote {
  // outcome: Int,
  // proposal: ProposalDatum,
  // proposal_name: AssetName,
  // stake: AssetName,
// }

// pub type ProposalMintRedeemer = (ByteArray, ProposalAction)
// pub type ProposalRedeemer = (ByteArray, ForumConfig, ProposalDatum, ProposalAction)

// pub type ProposalAction {
  // CreateProposal(ProposalState)
  // Vote(ProposalVote)
  // VoteOrder(ProposalVote)
  // BatchVote(List<ProposalVote>)
  // Advance
  // Execute
// }

// // MVP version will not support batch voting, complexity introduced in stake.ak

// validator base_proposal {
  // withdraw(r: ProposalRedeemer, _a, _c) {
    // // Here we want to allow the state transition to occur.
    // when r is {
      // (_, Voting(votes), Vote(_)) -> {
        // // The outcome chosen is provided in the redeemer.

        // // A direct vote must consume one or more stake threads, which must only change by the locks applied.
        // // A direct vote must also consume the proposal, which must only change by the number of votes on the outcome.
        // // The outcome must be the one specified in the vote, and must be a valid outcome for the proposal.
        // todo 
      // }// Uses stake logic
      // (_, Voting(votes), VoteOrder(_)) -> {
        // // must pass stake mint relevant logic?
        // // must be passed reference proposal? - No, we can just use the proposal name.
        // // A vote order must contain the proposal name, the stake thread, the outcome, and the voting amount.
        // todo
      // } // Uses stake logic / new token
      // (_, Voting(votes), BatchVote(_)) -> {
        // // Must be passed the orders to consume, the proposal, and the forum config.
        // // Calls to stake burn? - TODO

        // // All orders must contain proper state thread.
        // // This should be a duplicate of the stake 
        // // All orders must contain proper vote data.
        // todo
      // } // Merges Orders
      // (_, Voting(votes), Execute) -> {
        // // We must check that the outcome is the one with the most votes.
        // // We must check that the outcome has enough votes to be considered valid.
        // // We must check that the proposal voting time has passed.
        // // When executing, we must make sure to only mint
        // // - the correct amount of execution tokens
        // // - with the correct outputs
        // // - forum mint needs to be called with proper args
        // todo
      // } // Burns the proposal and mints execution token(s).
      // _ -> fail
    // }
  // }

  // mint(r: Data, _p, _t) {
    // // This must be called by the forum script in order to be passed the config and other necessary data.
    // // What if we just push to withdraw here?

    // // Here we handle the generation of the proposal NFT for a given proposal.
    // // Ensure only a single proposal is minted, and ensure it has a unique name.
    // // Ensure that the votes are initialized to 0.
    // // Ensure that the proposal contains a null outcome.
    // // Ensure the proposal goes back to the forum.

    // // Burning should be fine no?
    // todo
  // }

  // else(_) {
    // fail
  // }
// }
