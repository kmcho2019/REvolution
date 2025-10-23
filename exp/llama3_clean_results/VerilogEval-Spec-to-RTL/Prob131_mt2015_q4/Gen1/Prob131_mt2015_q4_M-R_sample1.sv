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
  wire a, b;

  // Directly computing outputs of Module A and Module B within topLevel
  assign a = (x ^ y) & x;
  assign b = ~(x ^ y);

  // Applying the required operations
  assign z = (a | b) ^ (a & b);
endmodule