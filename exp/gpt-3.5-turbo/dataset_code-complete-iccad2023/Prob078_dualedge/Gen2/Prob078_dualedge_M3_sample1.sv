module TopModule (
  input clk,
  input d,
  output reg q
);

reg q_reg;
reg delayed_clk;

always @(posedge clk) begin
  delayed_clk <= #1 clk;
  if (clk ^ delayed_clk) begin
    q_reg <= d;
  end
end

assign q = q_reg;

endmodule