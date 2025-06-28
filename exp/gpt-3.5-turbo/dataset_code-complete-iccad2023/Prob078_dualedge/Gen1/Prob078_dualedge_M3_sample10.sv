module TopModule (
  input clk,
  input d,
  output reg q
);

reg q1, q2;
reg q1_enable, q2_enable;

always @* begin
  q1_enable = !clk;
  q2_enable = clk;
end

always @(posedge clk or negedge clk) begin
  if (q1_enable)
    q1 <= d;
  if (q2_enable)
    q2 <= q1;
end

assign q = q2;

endmodule