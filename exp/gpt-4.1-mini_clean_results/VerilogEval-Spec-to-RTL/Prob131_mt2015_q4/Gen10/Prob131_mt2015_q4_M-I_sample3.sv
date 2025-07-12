module TopModule(input wire x, input wire y, output wire z);
  wire a_out;
  wire b_out;
  wire or_out, and_out;

  // Direct implementation of module A: z = (x ^ y) & x
  assign a_out = (x ^ y) & x;

  // Direct implementation of module B: z = ~(x ^ y) (XNOR)
  assign b_out = ~(x ^ y);

  // OR and AND gates as per original design
  assign or_out = a_out | b_out;
  assign and_out = a_out & b_out;

  // Final XOR output
  assign z = or_out ^ and_out;
endmodule