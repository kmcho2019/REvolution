module TopModule (
  input clk,
  input reset,
  input [31:0] in,
  output reg [31:0] out
);

reg [31:0] in_prev;

always @(posedge clk) begin
  // Store the previous input value
  in_prev <= in;

  // Compare current input with previous input for each bit
  for (int i = 0; i < 32; i = i + 1) begin
    if (in[i] && !in_prev[i]) begin
      out[i] <= 1; // Capture the change
    end
  end

  // Reset all output bits when reset signal is active
  if (reset) begin
    out <= 0;
  end
end

endmodule