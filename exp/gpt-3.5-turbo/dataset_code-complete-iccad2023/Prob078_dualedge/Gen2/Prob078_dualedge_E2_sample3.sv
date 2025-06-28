module TopModule (
  input clk,
  input d,
  output reg q
);

reg q_reg;
reg q_temp;

always @(posedge clk)
  q_reg <= d;

always @(negedge clk)
  q_temp <= ~q_reg;

always @*
  q = q_temp;

endmodule