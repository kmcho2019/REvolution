// Define Module A
module ModuleA(x, y, z);
  input x, y;
  output z;
  assign z = (x ^ y) & x;
endmodule

// Define Module B
module ModuleB(x, y, z);
  input x, y;
  output z;
  assign z = (x & y) | (!x & !y);
endmodule

// Define the top-level module
module toplevel(x, y, z);
  input x, y;
  output z;
  wire a1_out, a2_out, b1_out, b2_out, or_out, and_out;

  // Instantiate Module A and Module B
  ModuleA a1(x, y, a1_out);
  ModuleB b1(x, y, b1_out);
  ModuleA a2(x, y, a2_out);
  ModuleB b2(x, y, b2_out);

  // Connect outputs to OR and AND gates
  or or1(a1_out, b1_out, or_out);
  and and1(a2_out, b2_out, and_out);

  // Connect OR and AND outputs to XOR gate
  xor xor1(or_out, and_out, z);
endmodule