module d_flipflop (
  input clk,
  input d,
  input r,
  output reg q
);

always @(posedge clk or posedge r)
begin
  if (r)
    q <= 1'b0; // Active high synchronous reset
  else
    q <= d; // Update output on the positive edge of the clock when reset is not asserted
end

endmodule