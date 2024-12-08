// [ DEPRECATED ]

// use cardano/transaction.{Transaction}
// use cardano/assets.{PolicyId}
// use cardano/address.{Credential, Script}
// use common/utils.{check_withdraw_redeemer, check_proper_burn_with_policy}

// pub type ExecutionDatum {
  // execution_script: ByteArray,
  // execution_args: List<Data>,
// }

// pub type FinishProposal {
  // proposal_name: AssetName,
  // forum_hash: ByteArray
// }

// pub type ExecutionToken {
  // Mint(FinishProposal)
  // Burn
// }

// validator execution { // We need to pass in the forum script in the redeemer
  // withdraw(r: Data, c: Credential, tx: Transaction) {
    // // Here we should make sure that the token gets burnt and we should ensure that
    // // the script from the datum is executed correctly.
    // let Transaction { mint, inputs, redeemers, .. } = tx
    // expect Script(s) = c
    // let p: PolicyId = s
    // expect (forum_hash, ExecutionDatum { execution_script, execution_args }): (ByteArray, ExecutionDatum) =
      // r
    // check_withdraw_redeemer(redeemers, execution_script, execution_args) && check_proper_burn_with_policy(mint, inputs, forum_hash)
  // }

  // else(_) {
    // fail
  // }
// }
