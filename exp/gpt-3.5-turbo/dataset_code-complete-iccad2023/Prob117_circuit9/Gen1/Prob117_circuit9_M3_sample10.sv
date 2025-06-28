module TopModule (
  input clk,
  input a,
  output reg [2:0] q
);

reg [1:0] a_delay;

always @ (posedge clk) begin
  a_delay <= {a_delay[0], a}; // Delay 'a' by one clock cycle

  if (a_delay == 2'b01) begin // 'a' was high, now low
    q <= 3'b0; // Reset counter to 0
  end else if (a_delay[1] == 1'b1) begin
    if (q < 3'b110) // Increment counter if 'a' is high
      q <= q + 1;
  end
end

endmodule