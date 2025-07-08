module A (
  input x,
  input y,
  output z
);
  assign z = (x ^ y) & x;
endmodule

module B (
  input x,
  input y,
  output z
);
  // Implement B based on the waveform:
  // Observing the waveform and making a truth table for z with inputs x,y:
  // At (x,y) = (0,0): z=1
  // (1,0): z=0
  // (0,1): z=0
  // (1,1): z=1
  // The function z = (~x & ~y) | (x & y)
  // which is XNOR of x and y, or equivalently z = ~(x ^ y)
  assign z = ~(x ^ y);
endmodule

module TopModule (
  input x,
  input y,
  output z
);
  wire a1_out, a2_out, b1_out, b2_out;
  wire or_out, and_out;

  A a1 (.x(x), .y(y), .z(a1_out));
  A a2 (.x(x), .y(y), .z(a2_out));
  B b1 (.x(x), .y(y), .z(b1_out));
  B b2 (.x(x), .y(y), .z(b2_out));

  assign or_out = a1_out | b1_out;
  assign and_out = a2_out & b2_out;
  assign z = or_out ^ and_out;
endmodule