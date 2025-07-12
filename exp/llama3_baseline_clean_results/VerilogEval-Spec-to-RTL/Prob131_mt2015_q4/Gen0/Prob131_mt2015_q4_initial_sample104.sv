module A(x, y, z);
  input x;
  input y;
  output z;
  assign z = (x ^ y) & x;
endmodule

module B(x, y, z);
  input x;
  input y;
  output z;
  assign z = (~x & ~y) | (x & y);
endmodule

module top_level(x, y, z);
  input x;
  input y;
  output z;
  wire A1_out, B1_out, A2_out, B2_out, OR_out, AND_out;

  A A1(x, y, A1_out);
  B B1(x, y, B1_out);
  A A2(x, y, A2_out);
  B B2(x, y, B2_out);

  or or_gate(A1_out, B1_out, OR_out);
  and and_gate(A2_out, B2_out, AND_out);
  xor xor_gate(OR_out, AND_out, z);
endmodule