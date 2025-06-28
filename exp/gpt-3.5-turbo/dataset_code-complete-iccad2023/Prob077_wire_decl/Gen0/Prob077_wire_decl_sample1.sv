module AND_gate (
  input a,
  input b,
  output y
);
  assign y = a & b;
endmodule

module OR_gate (
  input a,
  input b,
  output y
);
  assign y = a | b;
endmodule

module TopModule (
  input a,
  input b,
  input c,
  input d,
  output out,
  output out_n
);
  wire intermediate_wire1, intermediate_wire2;

  AND_gate and_gate1 (a, b, intermediate_wire1);
  AND_gate and_gate2 (c, d, intermediate_wire2);
  
  OR_gate or_gate (intermediate_wire1, intermediate_wire2, out);

  assign out_n = ~out;
endmodule