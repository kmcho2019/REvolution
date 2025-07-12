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

module top_level(x, y, z);
  input x, y;
  output z;
  wire a1, a2, b1, b2, or_out, and_out;
  
  // Instantiate submodules
  A a1_sub(x, y, a1);
  B b1_sub(x, y, b1);
  A a2_sub(x, y, a2);
  B b2_sub(x, y, b2);
  
  // Connect to OR and AND gates
  or or_gate(a1, b1, or_out);
  and and_gate(a2, b2, and_out);
  
  // Connect to XOR gate
  xor xor_gate(or_out, and_out, z);
endmodule