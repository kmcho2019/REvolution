module DFlipFlop (
  input clk,
  input d,
  output reg q
);
  always @(posedge clk)
    q <= d;
endmodule

module XORGate (
  input a,
  input b,
  output c
);
  assign c = a ^ b;
endmodule

module ANDGate (
  input a,
  input b,
  output c
);
  assign c = a & b;
endmodule

module ORGate (
  input a,
  input b,
  output c
);
  assign c = a | b;
endmodule

module NOR3Gate (
  input a,
  input b,
  input c,
  output z
);
  assign z = ~(a | b | c);
endmodule

module TopModule (
  input clk,
  input x,
  output z
);
  wire x_bar;
  assign x_bar = ~x;
  
  wire d1, d2, d3;
  wire q1, q2, q3;
  
  XORGate XOR1(x, q1, d1);
  ANDGate AND1(x, x_bar, d2);
  ORGate OR1(x, x_bar, d3);
  
  DFlipFlop FF1(clk, d1, q1);
  DFlipFlop FF2(clk, d2, q2);
  DFlipFlop FF3(clk, d3, q3);
  
  NOR3Gate NORGate(q1, q2, q3, z);
endmodule