module XNOR_gate (
  input a,
  input b,
  output out
);

  wire xor_out;
  
  // XOR gate implementation
  xor_gate xor1 (
    .a(a),
    .b(b),
    .out(xor_out)
  );
  
  // NOT gate implementation
  not_gate not1 (
    .in(xor_out),
    .out(out)
  );

endmodule

module xor_gate (
  input a,
  input b,
  output out
);
  assign out = a ^ b;
endmodule

module not_gate (
  input in,
  output out
);
  assign out = ~in;
endmodule