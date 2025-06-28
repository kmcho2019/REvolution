module TopModule (
  input clk,
  input in,
  output reg out
);

  reg d_ff; // D flip-flop input
  wire xor_output;

  // Two-input XOR gate
  assign xor_output = in ^ d_ff;

  // D flip-flop with positive edge clock trigger
  always @(posedge clk)
    d_ff <= xor_output;

  assign out = d_ff;

endmodule