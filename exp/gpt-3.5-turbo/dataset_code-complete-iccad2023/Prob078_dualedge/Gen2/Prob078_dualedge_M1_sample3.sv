module TopModule (
  input clk,
  input d,
  output reg q
);

reg q_ff;

always @(posedge clk or negedge clk)
  q_ff <= d ^ q_ff;

assign q = q_ff;

endmodule