module ModuleA(x, y, z);
  input x, y;
  output z;
  assign z = (x ^ y) & x;
endmodule

module ModuleB(x, y, z);
  input x, y;
  output z;
  assign z = (x == y);
endmodule

module top_level(x, y, z);
  input x, y;
  output z;
  wire a1, a2, b1, b2, or_out, and_out;
  
  ModuleA A1(.x(x), .y(y), .z(a1));
  ModuleB B1(.x(x), .y(y), .z(b1));
  ModuleA A2(.x(x), .y(y), .z(a2));
  ModuleB B2(.x(x), .y(y), .z(b2));
  
  or or_gate(.a(a1), .b(b1), .y(or_out));
  and and_gate(.a(a2), .b(b2), .y(and_out));
  xor xor_gate(.a(or_out), .b(and_out), .y(z));
endmodule