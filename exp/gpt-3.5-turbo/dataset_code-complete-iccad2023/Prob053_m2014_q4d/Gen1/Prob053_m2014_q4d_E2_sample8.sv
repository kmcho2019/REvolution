module TopModule (
  input clk,
  input in,
  output logic out
);

  logic dff_input;
  logic xor_output;

  // XOR gate with current flip-flop output and input 'in'
  assign xor_output = dff_input ^ in;

  // D flip-flop to store the XOR result
  always_ff @(posedge clk)
    dff_input <= xor_output;

  // Output of the flip-flop
  assign out = dff_input;

endmodule