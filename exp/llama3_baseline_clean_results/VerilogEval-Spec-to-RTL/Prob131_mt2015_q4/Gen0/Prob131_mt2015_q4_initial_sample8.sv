// Define Module A
module A(x, y, z);
  input x, y;
  output z;
  assign z = (x ^ y) & x;
endmodule

// Define Module B
module B(x, y, z);
  input x, y;
  output z;
  assign z = (~x & ~y) | (x & y);
endmodule

// Top-level module
module top(x, y, z);
  input x, y;
  output z;
  
  wire a1_out, b1_out, a2_out, b2_out, or_out, and_out;
  
  // Instantiate first pair of A and B submodules
  A a1(x, y, a1_out);
  B b1(x, y, b1_out);
  
  // Instantiate second pair of A and B submodules
  A a2(x, y, a2_out);
  B b2(x, y, b2_out);
  
  // Connect outputs to OR and AND gates
  or or1(a1_out, b1_out, or_out);
  and and1(a2_out, b2_out, and_out);
  
  // Final XOR gate to produce output z
  xor xor1(or_out, and_out, z);
endmodule