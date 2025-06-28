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
  wire d1, d2, d3;
  wire q1, q2, q3;
  
  XORGate XOR(x, 0, d1);
  ANDGate AND(x, 1, d2);
  ORGate OR(x, 1, d3);
  
  DFlipFlop FF1(clk, d1, q1);
  DFlipFlop FF2(clk, d2, q2);
  DFlipFlop FF3(clk, d3, q3);
  
  NOR3Gate NORGate(q1, q2, q3, z);
endmodule