module TopModule (
  input clk,
  input d,
  output reg q
);

reg q_temp, q_previous;
reg clk_delayed;

always @ (posedge clk) begin
  q_temp <= d;
  clk_delayed <= ~clk;
end

always @ (*) begin
  if(clk_delayed & ~clk) begin
    q <= q_temp;
  end
  q_previous <= q_temp;
end

endmodule