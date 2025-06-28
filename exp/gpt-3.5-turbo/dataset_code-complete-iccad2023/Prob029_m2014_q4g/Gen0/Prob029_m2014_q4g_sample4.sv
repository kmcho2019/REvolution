module XNOR_GATE (
  input a,
  input b,
  output logic xnor_output
);
  assign xnor_output = ~(a ^ b);
endmodule

module TopModule (
  input in1,
  input in2,
  input in3,
  output logic out
);

  XNOR_GATE xnor_gate_inst (
    .a(in1),
    .b(in2),
    .xnor_output(xnor_output)
  );

  assign out = xnor_output ^ in3;

endmodule