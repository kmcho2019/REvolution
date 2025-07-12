module ModuleA(x, y, z);
  input x, y;
  output z;
  assign z = (x ^ y) & x;
endmodule

module ModuleB(x, y, z);
  input x, y;
  output z;
  assign z = ~(x ^ y);
endmodule

module TopLevelModule(x, y, z);
  input x, y;
  output z;
  wire a1, a2, b1, b2, or_out, and_out;
  
  ModuleA a_module1(x, y, a1);
  ModuleB b_module1(x, y, b1);
  ModuleA a_module2(x, y, a2);
  ModuleB b_module2(x, y, b2);
  
  or or_gate(b1, a1, or_out);
  and and_gate(b2, a2, and_out);
  xor xor_gate(or_out, and_out, z);
endmodule