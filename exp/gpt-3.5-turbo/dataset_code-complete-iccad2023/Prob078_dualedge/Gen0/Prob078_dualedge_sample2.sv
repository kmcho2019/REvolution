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

assign q = q2;

endmodule