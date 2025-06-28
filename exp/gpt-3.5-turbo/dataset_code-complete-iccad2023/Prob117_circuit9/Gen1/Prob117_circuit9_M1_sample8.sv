module TopModule (
  input clk,
  input a,
  output reg [2:0] q
);

reg [1:0] a_delay; // Delayed version of 'a' to detect consecutive low cycles

always @ (posedge clk) begin
  a_delay <= {a_delay[0], a}; // Delay 'a' for one clock cycle

  if (a == 1'b1) begin
    if (q < 3'd6) // Increment counter from 0 to 6
      q <= q + 1;
  end else begin
    if (a_delay == 2'b00) begin // Check if 'a' has been low for 2 consecutive cycles
      q <= 3'b0; // Reset counter to 0
    end
  end
end

endmodule