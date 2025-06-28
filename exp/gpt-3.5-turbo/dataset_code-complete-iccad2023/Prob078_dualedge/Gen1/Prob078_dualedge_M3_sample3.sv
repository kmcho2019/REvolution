module TopModule (
  input clk,
  input d,
  output reg q
);

reg q1, clk_prev;
wire clk_edge;

assign clk_edge = clk ^ clk_prev;

always @(posedge clk_edge) begin
  q1 <= d;
end

always @(posedge clk) begin
  clk_prev <= clk;
end

assign q = q1;

endmodule