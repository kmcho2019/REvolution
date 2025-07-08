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
  output reg z
);

  // From the waveform, let's deduce B's behavior:
  // The output z seems to be 1 mostly when (x,y) = (0,0) or (1,1)
  // and 0 otherwise, except some time-based variations.
  // The pattern suggests B implements z = ~(x ^ y)
  // But checking the waveform:
  // at (0,0) z=1, at (1,1) z=1, at (1,0) z=0, at (0,1) z=0
  // so z = ~(x ^ y) (XNOR)

  // Implement combinational logic for B according to this.
  always @(*) begin
    z = ~(x ^ y);
  end
endmodule

module TopModule (
  input x,
  input y,
  output z
);
  wire a1_out, a2_out;
  wire b1_out, b2_out;
  wire or_out, and_out;

  A a1(.x(x), .y(y), .z(a1_out));
  A a2(.x(x), .y(y), .z(a2_out));
  B b1(.x(x), .y(y), .z(b1_out));
  B b2(.x(x), .y(y), .z(b2_out));

  assign or_out = a1_out | b1_out;
  assign and_out = a2_out & b2_out;
  assign z = or_out ^ and_out;
endmodule