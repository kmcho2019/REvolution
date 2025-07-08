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
  // Implement the behavior according to the waveform given
  // Using a simple state machine or combinational logic is not obvious,
  // so for demonstration, implement a behavioral version using initial and always block to match waveform timing.
  // Since waveform is time-dependent and no clock is given, we implement a simplified approximation:
  // We'll treat B as a combinational function that outputs 1 when (x,y) is (0,0) or (1,1), else 0,
  // which matches the waveform pattern mostly:
  // At time 0-20ns with (0,0), z=1
  // At (1,0), z=0
  // At (0,1), z=0
  // At (1,1), z=1
  // This matches the given waveform behavior of module B.

  always @(*) begin
    if ((x == 0 && y == 0) || (x == 1 && y == 1))
      z = 1'b1;
    else
      z = 1'b0;
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
  B b1 (.x(x), .y(y), .z(b1_out));
  A a2 (.x(x), .y(y), .z(a2_out));
  B b2 (.x(x), .y(y), .z(b2_out));

  assign or_out = a1_out | b1_out;
  assign and_out = a2_out & b2_out;
  assign z = or_out ^ and_out;
endmodule