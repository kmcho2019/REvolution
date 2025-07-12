module ModuleA(x, y, z);
  input x, y;
  output z;
  assign z = (x ^ y) & x;
endmodule

module ModuleB(x, y, z);
  input x, y;
  output z;
  // From the simulation waveform, we can see that ModuleB's output is 1 when both x and y are 0,
  // and when both x and y are 1. Otherwise, the output is 0.
  assign z = (x == 0 && y == 0) || (x == 1 && y == 1);
endmodule

module TopLevel(x, y, z);
  input x, y;
  output z;
  wire a1_out, a2_out, b1_out, b2_out, or_out, and_out;
  
  ModuleA a1(x, y, a1_out);
  ModuleB b1(x, y, b1_out);
  ModuleA a2(x, y, a2_out);
  ModuleB b2(x, y, b2_out);
  
  or or_gate(a1_out, b1_out, or_out);
  and and_gate(a2_out, b2_out, and_out);
  xor xor_gate(or_out, and_out, z);
endmodule

module or(a, b, z);
  input a, b;
  output z;
  assign z = a | b;
endmodule

module and(a, b, z);
  input a, b;
  output z;
  assign z = a & b;
endmodule

module xor(a, b, z);
  input a, b;
  output z;
  assign z = a ^ b;
endmodule