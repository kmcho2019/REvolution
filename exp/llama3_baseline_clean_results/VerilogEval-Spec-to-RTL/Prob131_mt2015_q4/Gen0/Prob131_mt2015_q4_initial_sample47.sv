module ModuleA(x, y, z);
  input x, y;
  output z;
  assign z = (x ^ y) & x;
endmodule

module ModuleB(x, y, z);
  input x, y;
  output z;
  assign z = (x & y) | (~x & ~y);
endmodule

module topLevel(x, y, z);
  input x, y;
  output z;
  wire a1_out, a2_out, b1_out, b2_out, or_out, and_out;
  
  ModuleA a1(.x(x),.y(y),.z(a1_out));
  ModuleB b1(.x(x),.y(y),.z(b1_out));
  ModuleA a2(.x(x),.y(y),.z(a2_out));
  ModuleB b2(.x(x),.y(y),.z(b2_out));
  
  or or1(.a(a1_out),.b(b1_out),.y(or_out));
  and and1(.a(a2_out),.b(b2_out),.y(and_out));
  
  xor xor1(.a(or_out),.b(and_out),.y(z));
endmodule

module or(a, b, y);
  input a, b;
  output y;
  assign y = a | b;
endmodule

module and(a, b, y);
  input a, b;
  output y;
  assign y = a & b;
endmodule

module xor(a, b, y);
  input a, b;
  output y;
  assign y = a ^ b;
endmodule