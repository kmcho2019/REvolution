module NOR_gate (
  input a,
  input b,
  output out
);
  assign out = ~(a | b);
endmodule

module TopModule (
  input a,
  input b,
  output out
);
  NOR_gate nor_gate_inst (
    .a(a),
    .b(b),
    .out(out)
  );
endmodule