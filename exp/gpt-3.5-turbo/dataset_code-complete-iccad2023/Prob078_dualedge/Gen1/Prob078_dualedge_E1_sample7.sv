module TopModule (
  input clk,
  input d0,
  input d1,
  output reg q
);

reg current_d;

always @(posedge clk)
begin
  if (current_d == 0)
    current_d <= d1;
  else
    current_d <= d0;
end

always @(*)
begin
  q <= current_d;
end

endmodule