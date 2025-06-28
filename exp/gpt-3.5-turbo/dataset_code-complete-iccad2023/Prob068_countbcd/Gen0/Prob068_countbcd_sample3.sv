module TopModule (
  input clk,
  input reset,
  output [3:1] ena,
  output reg [15:0] q
);

// Internal signals
reg [15:0] q_next;

// BCD counter logic
always @ (posedge clk or posedge reset)
begin
  if (reset) begin
    q <= 16'b0; // Reset value
  end
  else begin
    q <= q_next;
  end
end

// Next-state logic
always @*
begin
  q_next = q;
  
  if (ena[1]) begin
    if (q[3:0] < 4'b1001)
      q_next[3:0] = q[3:0] + 4'b0001;
    else
      q_next[3:0] = 4'b0000;
  end

  if (ena[2]) begin
    if (q[7:4] < 4'b1001)
      q_next[7:4] = q[7:4] + 4'b0001;
    else
      q_next[7:4] = 4'b0000;
  end

  if (ena[3]) begin
    if (q[11:8] < 4'b1001)
      q_next[11:8] = q[11:8] + 4'b0001;
    else
      q_next[11:8] = 4'b0000;
  end

  if (q[15:12] < 4'b1001)
    q_next[15:12] = q[15:12] + 4'b0001;
  else
    q_next[15:12] = 4'b0000;

end

endmodule