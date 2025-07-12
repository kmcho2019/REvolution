// Define Module A
module A(x, y, z);
  input x, y;
  output z;
  assign z = (x ^ y) & x;
endmodule

// Define Module B
module B(x, y, z);
  input x, y;
  output z;
  reg z;
  always @(x, y)
    case ({x, y})
      2'b00: z = 1;
      2'b01: z = 0;
      2'b10: z = 0;
      2'b11: z = 1;
    endcase
endmodule

// Define the top-level module
module top(x, y, z);
  input x, y;
  output z;
  wire a1, a2, b1, b2, or_out, and_out;
  
  // Instantiate submodules
  A a1_mod(x, y, a1);
  A a2_mod(x, y, a2);
  B b1_mod(x, y, b1);
  B b2_mod(x, y, b2);
  
  // Connect submodules to OR and AND gates
  assign or_out = a1 | b1;
  assign and_out = a2 & b2;
  
  // Connect OR and AND gates to XOR gate
  assign z = or_out ^ and_out;
endmodule