module TopModule (
  input clk,
  input in,
  output logic out
);

  logic xor_input, flipflop_input;

  assign xor_input = in ^ out;

  always_ff @(posedge clk)
    flipflop_input <= xor_input;

  always_comb
    out = flipflop_input;

endmodule