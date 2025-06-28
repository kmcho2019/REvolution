module TopModule (
  input a,
  input b,
  input c,
  input d,
  output out,
  output out_n
);

  // Two intermediate wires to connect the AND gates with the OR gate
  wire intermediate1, intermediate2;

  // Two AND gates
  and gate1 (intermediate1, a, b);
  and gate2 (intermediate2, c, d);

  // OR gate
  or gate3 (out, intermediate1, intermediate2);

  // NOT gate
  assign out_n = ~out;

endmodule

module and (
  output out,
  input a,
  input b
);
  assign out = a & b;
endmodule

module or (
  output out,
  input a,
  input b
);
  assign out = a | b;
endmodule