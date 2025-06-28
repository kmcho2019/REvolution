module TopModule (
  input in1,
  input in2,
  input in3,
  output logic out
);

  logic xnor_out;
  
  assign xnor_out = ~(in1 ^ in2); // Two-input XNOR gate implementation

  assign out = xnor_out ^ in3; // Two-input XOR gate implementation
  
endmodule