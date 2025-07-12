module FuncModule #(parameter IS_A = 1) (
  input wire x,
  input wire y,
  output wire z
);
  // If IS_A==1, z = (x ^ y) & x (function A)
  // If IS_A==0, z = ~(x ^ y) (function B)
  assign z = IS_A ? ((x ^ y) & x) : ~(x ^ y);
endmodule

module TopModule(input wire x, input wire y, output wire z);
  wire a1_out, a2_out;
  wire b1_out, b2_out;
  wire or_out, and_out;

  // Instantiate two FuncModules configured as A
  FuncModule #(1) a1 (.x(x), .y(y), .z(a1_out));
  FuncModule #(1) a2 (.x(x), .y(y), .z(a2_out));

  // Instantiate two FuncModules configured as B
  FuncModule #(0) b1 (.x(x), .y(y), .z(b1_out));
  FuncModule #(0) b2 (.x(x), .y(y), .z(b2_out));

  // OR gate combining first pair outputs
  assign or_out = a1_out | b1_out;

  // AND gate combining second pair outputs
  assign and_out = a2_out & b2_out;

  // Final XOR gate for output
  assign z = or_out ^ and_out;
endmodule