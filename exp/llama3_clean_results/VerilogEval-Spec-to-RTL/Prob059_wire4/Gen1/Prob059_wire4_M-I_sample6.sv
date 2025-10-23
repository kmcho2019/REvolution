module TopModule(
  input  logic a,
  input  logic b,
  input  logic c,
  output logic w,
  output logic x,
  output logic y,
  output logic z
);

  // Direct assignments to create connections similar to physical wires
  assign w = a;
  assign x = b;
  assign y = b;
  assign z = c;

endmodule