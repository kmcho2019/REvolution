module A(input x, input y, output z);
  assign z = (x ^ y) & x;
endmodule

module B(input x, input y, output z);
  assign z = ~(x ^ y);
endmodule

module TopModule(input x, input y, output z);
  wire a, b;
  
  A a_inst(.x(x), .y(y), .z(a));
  B b_inst(.x(x), .y(y), .z(b));
  
  // Simplified: (a | b) ^ (a & b) == a ^ b
  assign z = a ^ b;
endmodule