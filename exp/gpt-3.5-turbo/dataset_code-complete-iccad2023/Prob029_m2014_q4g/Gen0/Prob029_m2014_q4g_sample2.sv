module TopModule (
  input in1,
  input in2,
  input in3,
  output logic out
);

  // XNOR gate implementation
  wire xnor_out;
  assign xnor_out = ~(in1 ^ in2);

  // XOR gate implementation
  assign out = xnor_out ^ in3;

endmodule