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
  assign z = (x & y) | (~x & ~y);
endmodule

module top_level(x, y, z);
  input x;
  input y;
  output z;
  wire a1, a2, b1, b2, or_out, and_out;

  A a1_module(x, y, a1);
  B b1_module(x, y, b1);
  A a2_module(x, y, a2);
  B b2_module(x, y, b2);

  assign or_out = a1 | b1;
  assign and_out = a2 & b2;
  assign z = or_out ^ and_out;
endmodule