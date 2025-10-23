module A(input wire x, input wire y, output wire z);
  // z = (x XOR y) AND x
  assign z = (x ^ y) & x;
endmodule

module B(input wire x, input wire y, output wire z);
  // z = XNOR of x and y
  assign z = ~(x ^ y);
endmodule

module TopModule(input wire x, input wire y, output wire z);
  wire a1_out, a2_out;
  wire b1_out, b2_out;
  wire or_out, and_out;

  // Instantiate two A modules
  (* keep = "true" *) A a1(.x(x), .y(y), .z(a1_out));
  (* keep = "true" *) A a2(.x(x), .y(y), .z(a2_out));

  // Instantiate two B modules
  (* keep = "true" *) B b1(.x(x), .y(y), .z(b1_out));
  (* keep = "true" *) B b2(.x(x), .y(y), .z(b2_out));

  // OR gate with first pair outputs
  assign or_out = a1_out | b1_out;

  // AND gate with second pair outputs
  assign and_out = a2_out & b2_out;

  // XOR gate combines OR and AND outputs for final output
  assign z = or_out ^ and_out;

endmodule