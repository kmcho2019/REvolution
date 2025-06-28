module TopModule (
  input clk,
  input in,
  output logic out
);

  logic flipflop_input;
  logic flipflop_output;

  // XOR operation between 'in' and flipflop_output
  assign flipflop_input = in ^ flipflop_output;

  // D flip-flop
  always_ff @(posedge clk)
    flipflop_output <= flipflop_input;

  assign out = flipflop_output;

endmodule