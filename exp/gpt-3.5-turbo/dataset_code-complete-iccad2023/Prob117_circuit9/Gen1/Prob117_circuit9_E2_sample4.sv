module TopModule (
  input clk,
  input a,
  output reg [2:0] q
);

reg [1:0] a_delay;

always @ (posedge clk) begin
  a_delay <= {a_delay[0], a}; // Delay 'a' by one clock cycle

  if (a_delay[1] == 1 && a_delay[0] == 0) begin
    q <= 3'b000; // Reset counter to 0 when 'a' transitions from 1 to 0
  end else if (a_delay[1] == 1) begin
    if (q < 3'b110)
      q <= q + 1; // Increment counter when 'clk' transitions from 0 to 1 and 'a' is high
  end
end

endmodule