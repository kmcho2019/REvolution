module TopModule(input wire x, input wire y, output wire z);
  // Intermediate signals representing module A outputs
  wire a_out1, a_out2;
  // Intermediate signals representing module B outputs
  wire b_out1, b_out2;
  // Signals after OR and AND gates
  wire or_out, and_out;

  // Module A logic: z = (x XOR y) AND x
  assign a_out1 = (x ^ y) & x;
  assign a_out2 = (x ^ y) & x;

  // Module B logic: z = XNOR of x and y (1 if equal, else 0)
  assign b_out1 = ~(x ^ y);
  assign b_out2 = ~(x ^ y);

  // OR gate on first pair outputs
  assign or_out = a_out1 | b_out1;

  // AND gate on second pair outputs
  assign and_out = a_out2 & b_out2;

  // XOR of OR and AND produces final output
  assign z = or_out ^ and_out;
endmodule