module TopModule (
  input clk,
  input d,
  output reg q
);

reg q_reg;
event clk_falling_edge;

always @(posedge clk) begin
  q_reg <= d;
  ->clk_falling_edge;
end

always @(clk or clk_falling_edge) begin
  q <= q_reg;
end

endmodule