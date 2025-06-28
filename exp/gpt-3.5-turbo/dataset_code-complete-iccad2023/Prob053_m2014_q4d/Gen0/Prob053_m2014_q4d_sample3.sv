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
  output out
);
  assign out = a ^ b;
endmodule

module TopModule (
  input clk,
  input in,
  output reg out
);
  reg d;
  wire x;

  XORGate xor_gate (
    .a(in),
    .b(out),
    .out(x)
  );

  DFlipFlop flip_flop (
    .clk(clk),
    .d(x),
    .q(out)
  );
endmodule