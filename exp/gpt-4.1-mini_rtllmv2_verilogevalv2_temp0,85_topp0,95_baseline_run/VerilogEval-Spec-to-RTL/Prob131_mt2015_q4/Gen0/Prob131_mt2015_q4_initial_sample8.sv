module A(input x, input y, output z);
  assign z = (x ^ y) & x;
endmodule

module B(input x, input y, output reg z);
  // Implement B to follow the waveform given.
  // We'll model B as a Mealy state machine or combinational logic.
  // From waveform, let's deduce the logic:

  // Observing the waveform:
  // When x=0,y=0 => z=1
  // When x=1,y=0 => z=0
  // When x=0,y=1 => z=0
  // When x=1,y=1 => z=1

  // This matches the logic: z = ~(x) & ~(y) | x & y
  // i.e. z = (x XNOR y)
  // But waveform shows at time 55ns with x=0,y=0 z=1 (matches)
  // At 25ns x=1,y=0 z=0 (matches)
  // At 35ns x=0,y=1 z=0 (matches)
  // At 45ns x=1,y=1 z=1 (matches)
  // So z = (x ~^ y)
  
  always @(*) begin
    z = ~(x ^ y);
  end
endmodule

module top(input x, input y, output z);
  wire a1, a2, b1, b2;
  wire or_out, and_out;

  A A1(.x(x), .y(y), .z(a1));
  A A2(.x(x), .y(y), .z(a2));
  B B1(.x(x), .y(y), .z(b1));
  B B2(.x(x), .y(y), .z(b2));

  assign or_out = a1 | b1;
  assign and_out = a2 & b2;
  assign z = or_out ^ and_out;
endmodule