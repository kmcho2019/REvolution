module TopModule (
  input clk,
  input a,
  input b,
  output reg q,
  output reg state
);

reg q_ff;

always @(posedge clk) begin
  if (a & ~b)
    q_ff <= ~q_ff;
end

always @(posedge clk) begin
  q <= q_ff;
  state <= q;
end

endmodule