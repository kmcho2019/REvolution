module XORGate (
  input a,
  input b,
  input c,
  input d,
  output q
);

  assign q = (a ^ b ^ c ^ d);

endmodule

module TopModule (
  input a,
  input b,
  input c,
  input d,
  output q
);

  XORGate xor_gate (
    .a(a),
    .b(b),
    .c(c),
    .d(d),
    .q(q)
  );

endmodule