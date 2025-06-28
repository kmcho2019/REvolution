module DFlipFlop (
  input clk,
  input d,
  output reg q
);

always @(posedge clk)
  q <= d;

endmodule

module TopModule (
  input clk,
  input [7:0] d,
  output reg [7:0] q
);

reg [7:0] q_temp;

DFlipFlop flipflop0 (.clk(clk), .d(d[0]), .q(q_temp[0]));
DFlipFlop flipflop1 (.clk(clk), .d(d[1]), .q(q_temp[1]));
DFlipFlop flipflop2 (.clk(clk), .d(d[2]), .q(q_temp[2]));
DFlipFlop flipflop3 (.clk(clk), .d(d[3]), .q(q_temp[3]));
DFlipFlop flipflop4 (.clk(clk), .d(d[4]), .q(q_temp[4]));
DFlipFlop flipflop5 (.clk(clk), .d(d[5]), .q(q_temp[5]));
DFlipFlop flipflop6 (.clk(clk), .d(d[6]), .q(q_temp[6]));
DFlipFlop flipflop7 (.clk(clk), .d(d[7]), .q(q_temp[7]));

always @*
  q = q_temp;

endmodule