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
  // Model B behavior according to the given waveform.
  // Since no clock or timing information is provided for B,
  // implement B as a combinational function that replicates the waveform behavior
  // based on current inputs. From waveform analysis:
  // z = 1 when (x,y) in {(0,0), (1,1)}
  // z = 0 otherwise.
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
  wire a1_out, a2_out;
  wire b1_out, b2_out;
  wire or_out, and_out;

  A a1 (.x(x), .y(y), .z(a1_out));
  A a2 (.x(x), .y(y), .z(a2_out));

  B b1 (.x(x), .y(y), .z(b1_out));
  B b2 (.x(x), .y(y), .z(b2_out));

  assign or_out = a1_out | b1_out;
  assign and_out = a2_out & b2_out;
  assign z = or_out ^ and_out;

endmodule