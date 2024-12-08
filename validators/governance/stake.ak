// [ DEPRECATED ]

// use cardano/address.{Credential}
// use cardano/assets.{AssetName, PolicyId}

// pub type StakeDatum {
  // owner: Credential,
  // delegate: Credential,
  // locks: List<(AssetName, Int)>,
  // stake_token: (PolicyId, AssetName),
  // // reward_token: (PolicyId, AssetName),
// }

// validator base_stake {
  // withdraw(r: StakeDatum, _a, tx) {
    // // Don't allow the user to remove locks before they should be able to.
    // // Only allow the user to remove the UTxO if the locks are removed or all are unlocked.
    // // When removing, we must burn the stake token.
    // // Require signature from owner, or delegate, delegate cannot take tokens.
    // True
  // }

  // mint(r: Data, _p, _t) {
    // // Here we handle the generation of the stake NFT for a given user.
    // // Ensure only a single stake is minted, and ensure it has a unique name.
    // // Ensure that the amount staked is correct.
    // // Ensure the stake UTxO goes back to the forum.
    // todo
  // }

  // else(_) {
    // fail
  // }
// }
