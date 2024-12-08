use cardano/assets.{AssetName, PolicyId, Value}
use cardano/transaction.{
  Datum,
  InlineDatum,
  Transaction,
  ScriptPurpose,
  Redeemer,
  Withdraw,
  Input,
}
use cardano/address.{Script}
use aiken/collection/list
use aiken/collection/pairs
use aiken/collection/dict

pub fn get_inline_data(datum: Datum) -> Data {
  when datum is {
    InlineDatum(d) -> d
    _ -> fail
  }
}

pub fn find_utxo_with_nft(
  forum_policy: PolicyId,
  forum_name: AssetName,
  tx: Transaction,
) {
  // First we find the element containing our control NFT.
  let Transaction { reference_inputs, inputs, .. } = tx
  let maybe_ref =
    list.find(
      reference_inputs,
      fn(i) {
        assets.quantity_of(i.output.value, forum_policy, forum_name) == 1
      },
    )
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
}

pub fn check_withdraw_redeemer(
  redeemers: Pairs<ScriptPurpose, Redeemer>,
  script_hash: ByteArray,
  expected_data: Data,
) {
  expect Some(rdmr) =
    redeemers
      |> pairs.get_first(Withdraw(Script(script_hash)))
  rdmr == expected_data
}

pub fn check_proper_burn(
  mint: Value,
  inputs: List<Input>,
  policy_id: PolicyId,
  f: fn(Input, Int) -> Int
) {
  (1 ==list.foldr(
      inputs,
      0,
      fn(input: Input, acc: Int) { f(input, acc) },
    ))
}

pub fn check_proper_burn_with_policy(
  mint: Value,
  inputs: List<Input>,
  policy_id: PolicyId,
) {
  let f = fn(input: Input, acc: Int) { acc + dict.foldr(assets.tokens(input.output.value, policy_id), 0, fn(_k, v, r) {v + r}) }
  expect (-1 == dict.foldr(assets.tokens(mint, policy_id), 0, fn(_k, v, r) {v + r}))
  check_proper_burn(mint, inputs, policy_id, f)
}

pub fn check_proper_burn_with_policy_and_name(
  mint: Value,
  inputs: List<Input>,
  policy_id: PolicyId,
  asset_name: AssetName,
) {
  expect (-1 == assets.quantity_of(mint, policy_id, asset_name))
  check_proper_burn(mint, inputs, policy_id, fn(input, acc) { acc + assets.quantity_of(input.output.value, policy_id, asset_name) })
}
