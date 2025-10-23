module ModuleA(x, y, z);
  input x, y;
  output z;
  assign z = (x ^ y) & x;
endmodule

module ModuleB(x, y, z);
  input x, y;
  output z;
  // Analyzing the waveform, Module B can be described as z = ~(x ^ y)
  assign z = ~(x ^ y);
endmodule

module TopLevel(x, y, z);
  input x, y;
  output z;
  wire a1, a2, b1, b2, or_out, and_out;
  
  ModuleA A1(.x(x), .y(y), .z(a1));
  ModuleA A2(.x(x), .y(y), .z(a2));
  ModuleB B1(.x(x), .y(y), .z(b1));
  ModuleB B2(.x(x), .y(y), .z(b2));
  
  or or1(.a(a1), .b(b1), .z(or_out));
  and and1(.a(a2), .b(b2), .z(and_out));
  xor xor1(.a(or_out), .b(and_out), .z(z));
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