module TopModule (
  input clk,
  input in,
  output logic out
);

  logic xor_output;
  logic flop_input;

  assign xor_output = in ^ out;

  always_ff @(posedge clk)
    flop_input <= xor_output;

  assign out = flop_input;

endmodule