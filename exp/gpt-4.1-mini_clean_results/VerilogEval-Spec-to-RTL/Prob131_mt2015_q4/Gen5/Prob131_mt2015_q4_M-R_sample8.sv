module A(input wire x, input wire y, output reg z);
  // Combinational block to implement z = (x XOR y) AND x
  always @* begin
    z = (x ^ y) & x;
  end
endmodule

module B(input wire x, input wire y, output reg z);
  // Combinational block to implement z = XNOR(x, y)
  always @* begin
    z = ~(x ^ y);
  end
endmodule

module TopModule(input wire x, input wire y, output wire z);
  wire a_out1, a_out2;
  wire b_out1, b_out2;
  wire or_out, and_out;

  // Instantiate first pair of A and B modules
  A a1(.x(x), .y(y), .z(a_out1));
  B b1(.x(x), .y(y), .z(b_out1));

  // Instantiate second pair of A and B modules
  A a2(.x(x), .y(y), .z(a_out2));
  B b2(.x(x), .y(y), .z(b_out2));

  // Combine outputs with OR and AND gates
  assign or_out = a_out1 | b_out1;
  assign and_out = a_out2 & b_out2;

  // Final output via XOR of or_out and and_out
  assign z = or_out ^ and_out;
endmodule