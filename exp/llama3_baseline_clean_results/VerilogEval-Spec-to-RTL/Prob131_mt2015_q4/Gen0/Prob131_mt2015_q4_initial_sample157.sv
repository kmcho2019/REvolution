module A(x, y, z);
  input x, y;
  output z;
  assign z = (x ^ y) & x;
endmodule

module B(x, y, z);
  input x, y;
  output z;
  assign z = (x & y) | (!x & !y);
endmodule

module top(x, y, z);
  input x, y;
  output z;
  wire a1, b1, a2, b2, or_out, and_out;
  
  A a1_inst(x, y, a1);
  B b1_inst(x, y, b1);
  A a2_inst(x, y, a2);
  B b2_inst(x, y, b2);
  
  assign or_out = a1 | b1;
  assign and_out = a2 & b2;
  assign z = or_out ^ and_out;
endmodule