module TopModule (
  input clk,
  input d,
  output reg q
);

reg q_reg, prev_d;

always @(posedge clk or negedge clk)
begin
  if(clk == 1'b1) begin
    prev_d <= d;
    q_reg <= d ^ prev_d;
  end
end

assign q = q_reg;

endmodule