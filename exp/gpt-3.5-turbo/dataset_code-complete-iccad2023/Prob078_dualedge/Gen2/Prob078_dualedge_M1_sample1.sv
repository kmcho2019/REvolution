module TopModule (
  input clk,
  input d,
  output reg q
);

reg q1, q2;

always @(posedge clk)
  q1 <= d;

always @(posedge clk)
  q2 <= q1;

always @(posedge clk)
  q <= q2;

endmodule