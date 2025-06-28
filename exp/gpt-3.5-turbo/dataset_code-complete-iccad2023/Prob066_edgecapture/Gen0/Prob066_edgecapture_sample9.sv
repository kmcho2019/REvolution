module TopModule (
  input clk,
  input reset,
  input [31:0] in,
  output reg [31:0] out
);

reg [31:0] prev_in;

always @(posedge clk) begin
  if (reset)
    out <= 32'b0; // Reset output when reset signal is high
  else begin
    for (int i = 0; i < 32; i = i + 1) begin
      if (prev_in[i] && !in[i])
        out[i] <= 1; // Set output to 1 on rising edge
      else
        out[i] <= 0;
    end
    prev_in <= in; // Update previous values at the end of the clock cycle
  end
end

endmodule