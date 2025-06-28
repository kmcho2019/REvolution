module BCD_Counter (
  input clk,
  input reset,
  output [3:1] ena,
  output reg [15:0] q
);

// BCD counter logic
always @ (posedge clk or posedge reset)
begin
  if (reset) begin
    q <= 16'b0; // Reset value
  end
  else begin
    if (ena[1] && q[3:0] < 4'b1001)
      q[3:0] <= q[3:0] + 4'b0001;
    if (ena[2] && q[7:4] < 4'b1001)
      q[7:4] <= q[7:4] + 4'b0001;
    if (ena[3] && q[11:8] < 4'b1001)
      q[11:8] <= q[11:8] + 4'b0001;
    if (q[15:12] < 4'b1001)
      q[15:12] <= q[15:12] + 4'b0001;
  end
end

endmodule