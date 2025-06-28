module TopModule (
  input clk,
  input x,
  output reg z
);

reg d_flipflop_x, d_flipflop_and, d_flipflop_or;

always @(posedge clk) begin
  d_flipflop_x <= x ^ d_flipflop_x;
  d_flipflop_and <= x & ~d_flipflop_and;
  d_flipflop_or <= x | ~d_flipflop_or;
end

assign z = ~(d_flipflop_x | d_flipflop_and | d_flipflop_or);

endmodule