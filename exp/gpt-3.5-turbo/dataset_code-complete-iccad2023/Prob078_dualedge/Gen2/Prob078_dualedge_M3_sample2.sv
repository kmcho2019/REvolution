module TopModule (
  input clk,
  input d,
  output reg q
);

reg q1, q2;

always @(posedge clk)
  q1 <= d;

always @(negedge clk)
  q2 <= q1;

always @(posedge q2)
  q <= q1;

endmodule