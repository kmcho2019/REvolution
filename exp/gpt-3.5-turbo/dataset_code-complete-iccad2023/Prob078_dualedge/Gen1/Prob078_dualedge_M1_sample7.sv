module TopModule (
  input clk,
  input d,
  output reg q
);

reg delayed_d;

always @(posedge clk) begin
  delayed_d <= d; // Capture input on the positive edge of the clock
  q <= delayed_d; // Update output on the positive edge of the clock
end

always @(negedge clk)
  #1 delayed_d <= d; // Delay the input on the negative edge to synchronize

endmodule