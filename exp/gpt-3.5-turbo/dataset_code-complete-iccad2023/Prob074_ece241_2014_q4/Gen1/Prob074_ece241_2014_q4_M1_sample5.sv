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
  DFlipFlop ff1 (.clk(clk), .d(x ^ d2), .q(d1));
  DFlipFlop ff2 (.clk(clk), .d(x & ~d2), .q(d2));
  DFlipFlop ff3 (.clk(clk), .d(x | ~d3), .q(d3));
  
  // Logic gates
  assign not_d1 = ~d1;
  assign not_d2 = ~d2;
  assign not_d3 = ~d3;

  assign z_output = ~(d1 | d2 | d3);
  
  assign z = z_output;
endmodule