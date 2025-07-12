module A(input wire x, input wire y, output wire z);
  // z = (x XOR y) AND x
  assign z = (x ^ y) & x;
endmodule

module B(input wire x, input wire y, output wire z);
  // z = XNOR(x, y) per waveform
  assign z = ~(x ^ y);
endmodule

module TopModule(input wire x, input wire y, output wire z);
  wire a, b;
  wire or_out, and_out;

  // Instantiate single A and B modules
  A A_inst(.x(x), .y(y), .z(a));
  B B_inst(.x(x), .y(y), .z(b));

  // OR gate: use outputs from single A and B
  assign or_out = a | b;

  // AND gate: use outputs from single A and B
  assign and_out = a & b;

  // XOR gate combining OR and AND outputs
  assign z = or_out ^ and_out;
endmodule