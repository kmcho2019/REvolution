module TopModule (
  input clk,
  input d,
  output reg q
);

reg q_temp;

always @(posedge clk or negedge clk)
begin
  q_temp <= d;
end

always @*
begin
  q <= q_temp;
end

endmodule