module XNOR_gate (
  input a,
  input b,
  output out
);
  
  assign out = !(a ^ b);

endmodule

module TopModule (
  input a,
  input b,
  output out
);
  
  XNOR_gate XNOR_inst (
    .a(a),
    .b(b),
    .out(out)
  );

endmodule