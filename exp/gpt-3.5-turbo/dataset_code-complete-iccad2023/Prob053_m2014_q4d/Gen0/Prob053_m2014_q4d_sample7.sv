module TopModule (
  input clk,
  input in,
  output logic out
);

  logic dff_input, xor_input;
  logic xor_output;

  always @(posedge clk) begin
    dff_input <= xor_output;
  end

  assign xor_input = in ^ dff_input;
  assign xor_output = xor_input;

  // D flip-flop
  always @(posedge clk) begin
    out <= dff_input;
  end

endmodule