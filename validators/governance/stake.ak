use cardano/address.{Credential}

pub type StakeDatum {
  delegate: Credential,
}

pub type StakeRedeemer =
  (ByteArray, StakeActionType)

pub type StakeActionType {
  Unlock
  ApplyNewLock
}

// Basically work on the redeemer as much as possible.

validator base_stake {
  withdraw(r: (StakeDatum, StakeRedeemer), _a, _c) {
    True
  }

  mint(r: Data, _p, _t) {
    // Here we handle the generation of the stake NFT for a given user.
    // Ensure only a single stake is minted, and ensure it has a unique name.
    // Ensure that the amount staked is correct.
    // Ensure the stake UTxO goes back to the forum.
    todo
  }

  else(_) {
    fail
  }
}
