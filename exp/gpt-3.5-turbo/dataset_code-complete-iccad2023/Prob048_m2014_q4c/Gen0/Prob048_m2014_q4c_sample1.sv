module DFF_with_Reset (
  input clk,
  input d,
  input r,
  output reg q
);

always @(posedge clk) begin
  if (r == 1) // Active high reset
    q <= 1'b0;
  else
    q <= d;
end

endmodule