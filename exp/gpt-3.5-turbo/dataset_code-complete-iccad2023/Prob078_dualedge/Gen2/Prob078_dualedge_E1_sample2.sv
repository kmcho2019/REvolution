module TopModule (
  input clk,
  input d,
  output reg q
);

reg d_ff, prev_clk;

always @(posedge clk or negedge clk) begin
  if (~prev_clk & clk) begin
    d_ff <= d;
  end
  if (prev_clk & ~clk) begin
    q <= d_ff;
  end
  prev_clk <= clk;
end

endmodule