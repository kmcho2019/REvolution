module ModuleA(x, y, z);
  input x, y;
  output z;
  assign z = (x ^ y) & x;
endmodule

module ModuleB(x, y, z);
  input x, y;
  output z;
  assign z = (x & y) | (~x & y);
endmodule

module TopLevel(x, y, z);
  input x, y;
  output z;
  wire out_A1, out_B1, out_A2, out_B2, out_OR, out_AND;

  ModuleA A1(x, y, out_A1);
  ModuleB B1(x, y, out_B1);
  ModuleA A2(x, y, out_A2);
  ModuleB B2(x, y, out_B2);

  assign out_OR = out_A1 | out_B1;
  assign out_AND = out_A2 & out_B2;
  assign z = out_OR ^ out_AND;
endmodule