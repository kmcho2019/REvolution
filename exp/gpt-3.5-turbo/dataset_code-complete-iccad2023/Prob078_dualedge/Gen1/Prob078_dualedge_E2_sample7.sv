module TopModule (
  input clk,
  input d,
  output reg q
);

reg q_reg;

always @ (posedge clk or negedge clk)
begin
  if (~clk)
    q_reg <= d; // Latch input 'd' when clk is low
  else
    q_reg <= q_reg; // Hold the value when clk is high
end

assign q = q_reg;

endmodule