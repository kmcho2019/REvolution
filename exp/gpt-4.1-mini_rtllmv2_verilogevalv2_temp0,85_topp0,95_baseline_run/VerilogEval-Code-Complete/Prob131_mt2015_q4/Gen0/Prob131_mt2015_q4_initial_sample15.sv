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
  // Based on the waveform, B produces 1 in specific cases:
  // Observing the waveform:
  // z = 1 when:
  //   x=0,y=0 => z=1
  //   x=1,y=1 => z=1
  // All other cases z=0
  always @(*) begin
    if ((x == 0 && y == 0) || (x == 1 && y == 1))
      z = 1;
    else
      z = 0;
  end
endmodule

module TopModule (
  input x,
  input y,
  output z
);
  wire a0, a1, b0, b1;
  wire or_out, and_out;

  A a_inst0 (.x(x), .y(y), .z(a0));
  A a_inst1 (.x(x), .y(y), .z(a1));
  B b_inst0 (.x(x), .y(y), .z(b0));
  B b_inst1 (.x(x), .y(y), .z(b1));

  assign or_out = a0 | b0;
  assign and_out = a1 & b1;
  assign z = or_out ^ and_out;
endmodule