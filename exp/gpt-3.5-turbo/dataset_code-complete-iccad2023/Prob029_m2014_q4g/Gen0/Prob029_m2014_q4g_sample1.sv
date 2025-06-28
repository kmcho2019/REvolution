module TopModule (
  input in1,
  input in2,
  input in3,
  output logic out
);

  logic xnor_out, xor_out;

  assign xnor_out = ~(in1 ^ in2); // XNOR gate
  assign xor_out = xnor_out ^ in3; // XOR gate

  assign out = xor_out; // Output of the module

endmodule