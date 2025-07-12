module top_level_module(x, y, z);
  input x, y;
  output z;

  // Module A implements z = (x^y) & x
  module ModuleA(x, y, z);
    input x, y;
    output z;
    assign z = (x ^ y) & x;
  endmodule

  // Module B implements z = ~(x ^ y)
  module ModuleB(x, y, z);
    input x, y;
    output z;
    assign z = ~(x ^ y);
  endmodule

  wire a1_out, a2_out, b1_out, b2_out, or_out, and_out;

  ModuleA a1(x, y, a1_out);
  ModuleB b1(x, y, b1_out);
  ModuleA a2(x, y, a2_out);
  ModuleB b2(x, y, b2_out);

  or or1(a1_out, b1_out, or_out);
  and and1(a2_out, b2_out, and_out);

  xor xor1(or_out, and_out, z);

  // primitive gates
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
endmodule