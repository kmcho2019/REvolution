module A (
  input wire x,
  input wire y,
  output wire z
);
  // z = (x ^ y) & x
  assign z = (x ^ y) & x;
endmodule

module B (
  input wire x,
  input wire y,
  output reg z
);
  // Implement the behavior as per the waveform given.
  // We can implement it as a function of x and y matching the waveform.
  // Observing the waveform:
  // For (x,y) = (0,0) => z = 1
  // (1,0) => 0
  // (0,1) => 0
  // (1,1) => 1
  // So z = (x & y) | (~x & ~y) = XNOR(x,y)
  // But waveform shows (0,0) = 1, (1,1) = 1, others 0 => z = XNOR(x,y)
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

  // Instantiate first A and B
  A a1(.x(x), .y(y), .z(a1_out));
  B b1(.x(x), .y(y), .z(b1_out));

  // Instantiate second A and B
  A a2(.x(x), .y(y), .z(a2_out));
  B b2(.x(x), .y(y), .z(b2_out));

  // First OR gate: a1_out OR b1_out
  assign or_out = a1_out | b1_out;

  // Second AND gate: a2_out AND b2_out
  assign and_out = a2_out & b2_out;

  // XOR gate: or_out XOR and_out
  assign z = or_out ^ and_out;

endmodule