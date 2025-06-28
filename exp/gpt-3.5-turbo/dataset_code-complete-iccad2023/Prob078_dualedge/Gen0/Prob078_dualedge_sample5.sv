module TopModule (
  input clk,
  input d,
  output reg q
);

reg q_pos, q_neg;

always @(posedge clk)
  q_pos <= d;

always @(negedge clk)
  q_neg <= q_pos;

assign q = q_neg;

endmodule