module TopModule (
  input clk,
  input reset,
  input [31:0] in,
  output reg [31:0] out
);

reg [31:0] prev_in;
reg [31:0] edge_detected;

always @(posedge clk) begin
  if (reset)
    out <= 32'b0; // Reset output when reset signal is high
  else begin
    prev_in <= in; // Update previous values at the beginning of the clock cycle
    for (int i = 0; i < 32; i = i + 1) begin
      if (prev_in[i] && !in[i] && !edge_detected[i])
        out[i] <= 1; // Set output to 1 on rising edge if not previously detected
      else if (edge_detected[i] && !reset)
        out[i] <= 1; // Maintain output at 1 if edge already detected until reset
      else
        out[i] <= 0; // Reset output to 0 if no rising edge detected or after reset
      edge_detected[i] <= prev_in[i] && !in[i]; // Update edge detection status
    end
  end
end

endmodule