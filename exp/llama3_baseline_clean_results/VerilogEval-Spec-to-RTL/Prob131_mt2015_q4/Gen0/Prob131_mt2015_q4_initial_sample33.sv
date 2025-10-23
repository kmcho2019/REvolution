module A(x, y, z);
  input x, y;
  output z;
  assign z = (x ^ y) & x;
endmodule

module B(x, y, z);
  input x, y;
  output z;
  assign z = (x & y) | (!x &!y);
endmodule

module top_level(x, y, z);
  input x, y;
  output z;
  wire out_A1, out_B1, out_A2, out_B2, out_OR, out_AND;

  A a1(x, y, out_A1);
  B b1(x, y, out_B1);
  A a2(x, y, out_A2);
  B b2(x, y, out_B2);

  or or_gate(out_OR, out_A1, out_B1);
  and and_gate(out_AND, out_A2, out_B2);
  xor xor_gate(z, out_OR, out_AND);
endmodule