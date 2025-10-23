module A(x, y, z);
  input x, y;
  output z;
  assign z = (x ^ y) & x;
endmodule

module B(x, y, z);
  input x, y;
  output z;
  assign z =!(x & y); // Implementation based on observation
endmodule

module top_level(x, y, z);
  input x, y;
  output z;
  wire a1, b1, a2, b2, or_out, and_out;
  
  A a_mod1(x, y, a1);
  B b_mod1(x, y, b1);
  A a_mod2(x, y, a2);
  B b_mod2(x, y, b2);
  
  assign or_out = a1 | b1;
  assign and_out = a2 & b2;
  assign z = or_out ^ and_out;
endmodule