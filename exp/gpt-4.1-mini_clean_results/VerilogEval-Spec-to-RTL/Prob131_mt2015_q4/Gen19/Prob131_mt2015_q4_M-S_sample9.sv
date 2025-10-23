module TopModule(input wire x, input wire y, output wire z);
  wire xor_xy = x ^ y;

  // First pair outputs
  wire a1 = xor_xy & x;
  wire b1 = ~(xor_xy);
  wire or_out = a1 | b1;

  // Second pair outputs
  wire a2 = xor_xy & x;
  wire b2 = ~(xor_xy);
  wire and_out = a2 & b2;

  // Final output
  assign z = or_out ^ and_out;
endmodule