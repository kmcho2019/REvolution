// Module A implementation
module ModuleA(x, y, z);
  input x, y;
  output z;
  assign z = (x ^ y) & x;
endmodule

// Module B implementation
module ModuleB(x, y, z);
  input x, y;
  output z;
  assign z = (x & y) | (~x & ~y);
endmodule

// Top-level module implementation
module TopLevel(x, y, z);
  input x, y;
  output z;
  wire a1_out, a2_out, b1_out, b2_out, or_out, and_out;
  
  // Instantiate Module A and Module B
  ModuleA A1(x, y, a1_out);
  ModuleA A2(x, y, a2_out);
  ModuleB B1(x, y, b1_out);
  ModuleB B2(x, y, b2_out);
  
  // Connect outputs to OR and AND gates
  or or1(a1_out, b1_out, or_out);
  and and1(a2_out, b2_out, and_out);
  
  // Connect outputs to XOR gate
  xor xor1(or_out, and_out, z);
endmodule