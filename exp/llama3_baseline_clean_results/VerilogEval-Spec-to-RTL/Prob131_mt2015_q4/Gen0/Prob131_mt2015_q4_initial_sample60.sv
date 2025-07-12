module ModuleA(x, y, z);
  input x;
  input y;
  output z;
  assign z = (x ^ y) & x;
endmodule

module ModuleB(x, y, z);
  input x;
  input y;
  output z;
  assign z = (x == y) ? 1'b1 : 1'b0;
endmodule

module TopLevel(x, y, z);
  input x;
  input y;
  output z;
  wire a1, b1, a2, b2, or_out, and_out;
  
  ModuleA A1(x, y, a1);
  ModuleB B1(x, y, b1);
  ModuleA A2(x, y, a2);
  ModuleB B2(x, y, b2);
  
  or or1(a1, b1, or_out);
  and and1(a2, b2, and_out);
  xor xor1(or_out, and_out, z);
endmodule