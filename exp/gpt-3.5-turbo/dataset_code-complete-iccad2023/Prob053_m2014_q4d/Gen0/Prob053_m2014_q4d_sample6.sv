module TopModule (
  input clk,
  input in,
  output logic out
);

  logic xor_output;
  logic dff_input;

  // XOR gate
  assign xor_output = in ^ out;

  // D flip-flop
  always_ff @(posedge clk)
    dff_input <= xor_output;

  assign out = dff_input;

endmodule