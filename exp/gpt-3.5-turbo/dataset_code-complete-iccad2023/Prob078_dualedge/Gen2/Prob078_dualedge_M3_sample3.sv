module TopModule (
  input clk,
  input d,
  output reg q
);

reg q_next;

always @ (posedge clk or negedge clk)
  q_next <= d;

always @*
  q <= q_next;

endmodule