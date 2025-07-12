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

module topLevel(x, y, z);
  input x, y;
  output z;
  wire a1, b1, a2, b2;

  ModuleA a1Inst(x, y, a1);
  ModuleB b1Inst(x, y, b1);
  ModuleA a2Inst(x, y, a2);
  ModuleB b2Inst(x, y, b2);

  assign z = (a1 | b1) ^ (a2 & b2);
endmodule