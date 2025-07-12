module A(x, y, z);
  input x, y;
  output z;
  assign z = (x ^ y) & x;
endmodule

module B(x, y, z);
  input x, y;
  output z;
  assign z = ~(x ^ y);
endmodule

module top(x, y, z);
  input x, y;
  output z;
  wire a1, b1, a2, b2, or_out, and_out;
  
  A A1(x, y, a1);
  B B1(x, y, b1);
  A A2(x, y, a2);
  B B2(x, y, b2);
  
  or or1(a1, b1, or_out);
  and and1(a2, b2, and_out);
  xor xor1(or_out, and_out, z);
endmodule