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
  input x,
  output z
);
  wire d1, d2, d3;
  wire q1, q2, q3;
  
  DFlipFlop FF1(clk, x ^ q1, q1);
  DFlipFlop FF2(clk, ~(x & q2), q2);
  DFlipFlop FF3(clk, ~q3, q3);
  
  assign z = ~(q1 | q2 | q3);
endmodule