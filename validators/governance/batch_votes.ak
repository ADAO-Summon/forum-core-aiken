use cardano/transaction.{Transaction}
use cardano/assets.{AssetName}

pub type BatchVotesRedeemer = (ByteArray, AssetName, Data)

validator action {
  withdraw(relevant_info: Data, _c, tx: Transaction) {
    todo
  }

  else(_) {
    fail
  }
}
