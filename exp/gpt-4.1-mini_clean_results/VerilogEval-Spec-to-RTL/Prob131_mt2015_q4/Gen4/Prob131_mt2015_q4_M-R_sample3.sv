module A(input wire x, input wire y, output wire z);
  // z = (x XOR y) AND x
  assign z = (x ^ y) & x;
endmodule

module B(input wire x, input wire y, output wire z);
  // z = XNOR(x, y) per waveform
  assign z = ~(x ^ y);
endmodule

module TopModule(input wire x, input wire y, output wire z);
  wire a1, a2;
  wire b1, b2;
  wire or_out, and_out;

  // Instantiate two A modules
  A A1 (.x(x), .y(y), .z(a1));
  A A2 (.x(x), .y(y), .z(a2));

  // Instantiate two B modules
  B B1 (.x(x), .y(y), .z(b1));
  B B2 (.x(x), .y(y), .z(b2));

  // OR gate for first pair
  assign or_out = a1 | b1;

  // AND gate for second pair
  assign and_out = a2 & b2;

  // XOR gate combining OR and AND outputs
  assign z = or_out ^ and_out;
endmodule