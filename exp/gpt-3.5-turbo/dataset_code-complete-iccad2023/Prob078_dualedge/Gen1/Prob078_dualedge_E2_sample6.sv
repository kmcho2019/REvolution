module TopModule (
  input clk,
  input d,
  output reg q
);

reg q1, q2;
reg clk_inv;

always @(posedge clk)
  clk_inv <= ~clk;

always @(posedge clk or negedge clk) begin
  if (clk_inv)
    q1 <= d;
  else
    q2 <= q1;
end

assign q = q2;

endmodule