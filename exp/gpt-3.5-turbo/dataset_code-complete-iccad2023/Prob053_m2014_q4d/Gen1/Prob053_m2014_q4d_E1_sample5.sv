module TopModule (
  input clk,
  input in,
  output logic out
);

  logic dff_input, xor_output, enable;

  // XOR gate
  assign xor_output = in ^ dff_input;

  // D flip-flop with enable
  always @(posedge clk) begin
    if (enable) begin
      out <= dff_input;
    end
  end

  // Update D input and enable based on XOR output
  always @(*) begin
    dff_input = xor_output;
    enable = 1;
  end

endmodule