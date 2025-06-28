module TopModule (
  input clk,
  input d,
  output reg q
);

reg q_prev;

always @ (posedge clk or negedge clk)
begin
  if (clk != 1'b0)
    q <= d;
  else if (clk != 1'b1)
    q <= q_prev;
  q_prev <= q; // Store previous output value
end

endmodule