`timescale 1ns/1ps

module A(input x, input y, output z);
  assign z = (x ^ y) & x;
endmodule

module B(input x, input y, output reg z);
  // Implement B based on the waveform pattern.
  // Observing the waveform:
  // For (x,y) = (0,0) z=1
  // For (1,0) z=0
  // For (0,1) z=0
  // For (1,1) z=1
  // Except at some times, but since no clock or timing info is given,
  // we implement combinational logic matching the waveform pattern.
  // The pattern matches z = ~(x ^ y) = x XNOR y
  always @(*) begin
    z = ~(x ^ y);
  end
endmodule

module top(input x, input y, output z);
  wire a1_out, a2_out, b1_out, b2_out;
  wire or_out, and_out;

  A a1(.x(x), .y(y), .z(a1_out));
  A a2(.x(x), .y(y), .z(a2_out));
  B b1(.x(x), .y(y), .z(b1_out));
  B b2(.x(x), .y(y), .z(b2_out));

  assign or_out = a1_out | b1_out;
  assign and_out = a2_out & b2_out;
  assign z = or_out ^ and_out;
endmodule