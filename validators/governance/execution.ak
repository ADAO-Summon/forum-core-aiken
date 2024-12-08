use cardano/transaction.{Datum, Redeemer, Transaction}
use cardano/assets.{PolicyId, AssetName}
use cardano/address.{Credential, Script}
use common/utils.{check_withdraw_redeemer, check_proper_burn_with_policy, check_proper_burn_with_policy_and_name}

pub type ExecutionDatum {
  execution_script: ByteArray,
  execution_args: List<Data>,
}

pub type FinishProposal {
  forum_hash: ByteArray,
  proposal_policy: PolicyId,
  proposal_name: AssetName,
}

pub type ExecutionRedeemer { // This is actually the datum, but it is the redeemer here.
  Mint(FinishProposal)
  Burn(ExecutionDatum)
}

validator execution {
  withdraw(r: Data, c: Credential, tx: Transaction) {
    // Here we should make sure that the token gets burnt and we should ensure that
    // the script from the datum is executed correctly.
    let Transaction { mint, inputs, redeemers, .. } = tx
    expect Script(s) = c
    let p: PolicyId = s
    expect Burn (ExecutionDatum { execution_script, execution_args }): ExecutionRedeemer =
      r
    check_withdraw_redeemer(redeemers, execution_script, execution_args) && check_proper_burn_with_policy(mint, inputs, p)
  }

  mint(r: ExecutionRedeemer, p: PolicyId, t: Transaction) {
    // In order to mint the execution token, we need to make sure that we are burning a proposal.
    when r is {
      Mint(FinishProposal { proposal_policy, proposal_name, forum_hash }) -> {
        let Transaction { mint, inputs, .. } = t
        check_proper_burn_with_policy_and_name(mint, inputs, proposal_policy, proposal_name)
      }
      Burn(_) -> {
        let Transaction { mint, inputs, .. } = t
        check_proper_burn_with_policy(mint, inputs, p)
      }
    }
  }

  else(_) {
    fail
  }
}
