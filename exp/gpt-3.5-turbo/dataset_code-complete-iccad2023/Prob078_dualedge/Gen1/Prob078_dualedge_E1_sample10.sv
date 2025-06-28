module TopModule (
  input clk,
  input d,
  output reg q
);

reg q_ff;

always @(posedge clk)
  q_ff <= d;

assign q = q_ff ^ d;

endmodule