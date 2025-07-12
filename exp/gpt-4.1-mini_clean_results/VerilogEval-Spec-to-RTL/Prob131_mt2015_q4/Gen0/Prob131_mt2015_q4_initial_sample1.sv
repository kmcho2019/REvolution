module A(input x, input y, output z);
  assign z = (x ^ y) & x;
endmodule

// Module B based on the given waveform.
// After analyzing the waveform:
// z=1 when (x,y) in {(0,0),(1,1)}, else z=0
// The waveform matches z = ~(x ^ y), which is XNOR of x and y
module B(input x, input y, output z);
  assign z = ~(x ^ y);
endmodule

module top_module(input x, input y, output z);
  wire a1, a2, b1, b2;
  wire or_out, and_out;

  // Instantiate two A modules
  A A1(.x(x), .y(y), .z(a1));
  A A2(.x(x), .y(y), .z(a2));

  // Instantiate two B modules
  B B1(.x(x), .y(y), .z(b1));
  B B2(.x(x), .y(y), .z(b2));

  // First OR gate with outputs of A1 and B1
  assign or_out = a1 | b1;

  // Second AND gate with outputs of A2 and B2
  assign and_out = a2 & b2;

  // XOR gate of OR and AND outputs drives z
  assign z = or_out ^ and_out;
endmodule