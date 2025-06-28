module TopModule (
  input clk,
  input a,
  output reg q
);

reg q_reg;
always @(posedge clk) begin
  q_reg <= a;
end

assign q = q_reg;

endmodule