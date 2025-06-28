module TopModule (
  input in1,
  input in2,
  output logic out
);

  // Inverter for in2
  wire inv_in2;
  assign inv_in2 = ~in2;

  // AND gate
  assign out = in1 & inv_in2;

endmodule