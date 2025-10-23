module A(x, y, z);
  input x, y;
  output z;
  assign z = (x ^ y) & x;
endmodule

module B(x, y, z);
  input x, y;
  output z;
  assign z = (x & y) | (~x & ~y);
endmodule

module top_level(x, y, z);
  input x, y;
  output z;
  wire a1, a2, b1, b2, or_out, and_out;
  
  A a_module1(x, y, a1);
  B b_module1(x, y, b1);
  A a_module2(x, y, a2);
  B b_module2(x, y, b2);
  
  assign or_out = a1 | b1;
  assign and_out = a2 & b2;
  assign z = or_out ^ and_out;
endmodule