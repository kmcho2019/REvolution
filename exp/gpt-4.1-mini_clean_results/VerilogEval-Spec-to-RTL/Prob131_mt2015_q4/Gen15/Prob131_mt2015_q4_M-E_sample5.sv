module A(input wire x, input wire y, output wire z);
  // Implement z = (x XOR y) AND x
  assign z = (x ^ y) & x;
endmodule

module B(input wire x, input wire y, output wire z);
  // Implement z = XNOR(x, y)
  assign z = ~(x ^ y);
endmodule

module PairLogic(input wire x, input wire y, output wire z);
  wire a_out, b_out;
  wire or_out, and_out, xor_out;

  // Instantiate internal A and B modules for one pair
  A a(.x(x), .y(y), .z(a_out));
  B b(.x(x), .y(y), .z(b_out));

  // OR gate combining A and B outputs
  assign or_out = a_out | b_out;

  // AND gate combining A and B outputs
  assign and_out = a_out & b_out;

  // XOR gate combining OR and AND outputs
  assign xor_out = or_out ^ and_out;

  assign z = xor_out;
endmodule

module TopModule(input wire x, input wire y, output wire z);
  wire pair0_out, pair1_out;

  // Instantiate two PairLogic modules with same inputs
  PairLogic pair0(.x(x), .y(y), .z(pair0_out));
  PairLogic pair1(.x(x), .y(y), .z(pair1_out));

  // Final output is OR of the two PairLogic outputs
  assign z = pair0_out | pair1_out;
endmodule