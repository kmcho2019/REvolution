module A(input x, input y, output z);
  assign z = (x ^ y) & x;
endmodule

module B(input x, input y, output z);
  // Analyze waveform for B:
  // Input combinations and corresponding output:
  // x y | z
  // 0 0 | 1
  // 1 0 | 0
  // 0 1 | 0
  // 1 1 | 1
  // This matches z = (x & y) | (~x & ~y) i.e. x XNOR y.
  assign z = ~(x ^ y);
endmodule

module top(input x, input y, output z);
  wire a1, a2, b1, b2;
  wire or_out, and_out;

  // instantiate two A modules
  A A1(.x(x), .y(y), .z(a1));
  A A2(.x(x), .y(y), .z(a2));

  // instantiate two B modules
  B B1(.x(x), .y(y), .z(b1));
  B B2(.x(x), .y(y), .z(b2));

  assign or_out = a1 | b1;
  assign and_out = a2 & b2;
  assign z = or_out ^ and_out;
endmodule