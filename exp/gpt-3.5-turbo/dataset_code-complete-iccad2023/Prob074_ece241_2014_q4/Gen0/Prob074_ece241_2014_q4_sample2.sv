module DFlipFlop (
  input clk,
  input d,
  output reg q
);
  // D flip-flop behavior
  always @(posedge clk)
    q <= d;
endmodule

module TopModule (
  input clk,
  input x,
  output z
);
  reg d1, d2, d3;
  reg not_d1, not_d2, not_d3;
  reg z_output;
  
  // Instantiate D flip-flops
  DFlipFlop ff1 (.clk(clk), .d(d1), .q(d1));
  DFlipFlop ff2 (.clk(clk), .d(d2), .q(d2));
  DFlipFlop ff3 (.clk(clk), .d(d3), .q(d3));
  
  // Logic gates
  assign not_d1 = ~d1;
  assign not_d2 = ~d2;
  assign not_d3 = ~d3;

  assign d1 = x ^ d2;
  assign d2 = x & not_d2;
  assign d3 = x | not_d3;

  assign z_output = ~(d1 | d2 | d3);
  
  assign z = z_output;
endmodule