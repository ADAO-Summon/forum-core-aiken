use cardano/transaction.{Datum, InlineDatum}
pub fn get_inline_data(datum: Datum) -> Data {
  when datum is {
    InlineDatum(d) -> d
    _ -> fail
  }
}