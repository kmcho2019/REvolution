module A(input x, input y, output z);
  assign z = (x ^ y) & x;
endmodule

module B(input x, input y, output z);
  // Implementing B based on given waveform data as a truth table:
  // x y | z
  // 0 0 | 1
  // 0 1 | 0
  // 1 0 | 0
  // 1 1 | 1
  assign z = (~x & ~y) | (x & y);
endmodule

module top(input x, input y, output z);
  wire a1_out, a2_out;
  wire b1_out, b2_out;
  wire or_out, and_out;

  A A1(.x(x), .y(y), .z(a1_out));
  A A2(.x(x), .y(y), .z(a2_out));

  B B1(.x(x), .y(y), .z(b1_out));
  B B2(.x(x), .y(y), .z(b2_out));

  assign or_out = a1_out | b1_out;
  assign and_out = a2_out & b2_out;
  assign z = or_out ^ and_out;
endmodule