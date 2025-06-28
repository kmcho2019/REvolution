module DFF_with_async_reset (
  input clk,
  input d,
  input areset,
  output reg q
);

always @(posedge clk or posedge areset)
begin
  if (areset)
    q <= 8'b00000000; // Reset output to 0
  else
    q <= d;
end

endmodule

module TopModule (
  input clk,
  input [7:0] d,
  input areset,
  output reg [7:0] q
);

DFF_with_async_reset DFF0 (.clk(clk), .d(d[0]), .areset(areset), .q(q[0]));
DFF_with_async_reset DFF1 (.clk(clk), .d(d[1]), .areset(areset), .q(q[1]));
DFF_with_async_reset DFF2 (.clk(clk), .d(d[2]), .areset(areset), .q(q[2]));
DFF_with_async_reset DFF3 (.clk(clk), .d(d[3]), .areset(areset), .q(q[3]));
DFF_with_async_reset DFF4 (.clk(clk), .d(d[4]), .areset(areset), .q(q[4]));
DFF_with_async_reset DFF5 (.clk(clk), .d(d[5]), .areset(areset), .q(q[5]));
DFF_with_async_reset DFF6 (.clk(clk), .d(d[6]), .areset(areset), .q(q[6]));
DFF_with_async_reset DFF7 (.clk(clk), .d(d[7]), .areset(areset), .q(q[7]));

endmodule