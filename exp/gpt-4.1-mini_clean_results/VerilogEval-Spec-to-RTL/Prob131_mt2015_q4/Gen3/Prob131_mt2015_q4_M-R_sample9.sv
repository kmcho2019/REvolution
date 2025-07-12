module A(input wire x, input wire y, output wire z);
  wire xor_xy;
  assign xor_xy = x ^ y;
  assign z = xor_xy & x;
endmodule

module B(input wire x, input wire y, output wire z);
  wire xor_xy;
  assign xor_xy = x ^ y;
  assign z = ~xor_xy;
endmodule

module TopModule(input wire x, input wire y, output wire z);
  wire a_out1, a_out2;
  wire b_out1, b_out2;
  wire or_result, and_result;

  // Instantiate two A modules
  A a_inst1 (.x(x), .y(y), .z(a_out1));
  A a_inst2 (.x(x), .y(y), .z(a_out2));

  // Instantiate two B modules
  B b_inst1 (.x(x), .y(y), .z(b_out1));
  B b_inst2 (.x(x), .y(y), .z(b_out2));

  // OR gate combining first A and B outputs
  assign or_result = a_out1 | b_out1;

  // AND gate combining second A and B outputs
  assign and_result = a_out2 & b_out2;

  // Final XOR combining OR and AND results
  assign z = or_result ^ and_result;
endmodule