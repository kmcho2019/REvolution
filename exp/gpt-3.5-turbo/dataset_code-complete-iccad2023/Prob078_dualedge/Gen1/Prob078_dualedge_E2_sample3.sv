module TopModule (
  input clk,
  input d,
  output reg q
);

reg q_reg;
reg clk_div;

always @(posedge clk or negedge clk) begin
  clk_div <= ~clk_div;
end

always @(posedge clk_div) begin
  q_reg <= d;
end

assign q = q_reg;

endmodule