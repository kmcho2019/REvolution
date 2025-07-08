module TopModule (
  input clk,
  input [7:0] d,
  input reset,
  output reg [7:0] q
);

always @(negedge clk) begin
  if (reset) begin
    q <= 8'h34;  // Reset to 0x34 when reset is high
  end
  else begin
    q <= d;      // Otherwise pass input to output
  end
end

endmodule