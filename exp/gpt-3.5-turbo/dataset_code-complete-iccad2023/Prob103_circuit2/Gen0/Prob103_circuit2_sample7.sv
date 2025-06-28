module TopModule (
  input a,
  input b,
  input c,
  input d,
  output q
);

  wire condition1, condition2, condition3, condition4;

  assign condition1 = ~(a|b|c|d); // a NOR b NOR c NOR d
  assign condition2 = ~(~a|~b|~c|~d); // NOT a NOR NOT b NOR NOT c NOR NOT d
  assign condition3 = condition1 & condition2; // condition1 AND condition2
  assign condition4 = a | b | c | d; // a OR b OR c OR d

  assign q = condition3 & condition4; // condition3 AND condition4

endmodule