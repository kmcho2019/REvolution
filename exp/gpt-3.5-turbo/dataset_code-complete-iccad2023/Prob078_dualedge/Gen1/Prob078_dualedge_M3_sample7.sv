module TopModule (
  input clk,
  input d,
  output reg q
);

reg q_reg;

always @ (posedge clk or negedge clk)
begin
  q_reg <= d;
  if (~$past(clock)) begin
    q <= q_reg;
  end
end

endmodule