use cardano/transaction.{Transaction}

validator action {
  withdraw(relevant_info: Data, _c, tx: Transaction) {
    todo
  }

  else(_) {
    fail
  }
}