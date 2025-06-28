module TopModule (
  input clk,
  input in,
  output logic out
);

  logic xor_output, dff_input;

  assign xor_output = in ^ out;

  always_ff @(posedge clk)
    dff_input <= xor_output;

  assign out = dff_input;

endmodule