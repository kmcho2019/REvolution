module A(input wire x, input wire y, output reg z);
  // z = (x XOR y) AND x implemented in always_comb
  always @(*) begin
    z = (x ^ y) & x;
  end
endmodule

module B(input wire x, input wire y, output reg z);
  // z = XNOR of x and y implemented in always_comb
  always @(*) begin
    z = ~(x ^ y);
  end
endmodule

module TopModule(input wire x, input wire y, output wire z);
  wire a1_out, b1_out;
  wire a2_out, b2_out;
  wire or_out, and_out;

  // First pair of A and B modules
  A a1(.x(x), .y(y), .z(a1_out));
  B b1(.x(x), .y(y), .z(b1_out));

  // Second pair of A and B modules
  A a2(.x(x), .y(y), .z(a2_out));
  B b2(.x(x), .y(y), .z(b2_out));

  // OR gate combining first pair outputs
  assign or_out = a1_out | b1_out;

  // AND gate combining second pair outputs
  assign and_out = a2_out & b2_out;

  // XOR of OR and AND outputs as final z
  assign z = or_out ^ and_out;
endmodule