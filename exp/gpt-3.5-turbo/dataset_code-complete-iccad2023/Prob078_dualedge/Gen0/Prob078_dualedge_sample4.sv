module TopModule (
  input clk,
  input d,
  output reg q
);

reg q_pos, q_neg;

always @(posedge clk)
  q_pos <= d;

always @(negedge clk)
  q_neg <= d;

always @(posedge clk)
  q <= q_pos;

always @(posedge clk or negedge clk)
  q_pos <= q_neg;

endmodule