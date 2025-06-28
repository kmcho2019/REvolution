module TopModule (
  input in1,
  input in2,
  input in3,
  output logic out
);

  logic xnor_out1, xnor_out2;

  // First stage: XNOR gates
  assign xnor_out1 = in1 ^ in2;
  assign xnor_out2 = ~in1 ^ ~in2;

  // Second stage: XOR gate
  assign out = xnor_out1 ^ in3;
  
endmodule