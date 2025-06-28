module TopModule (
  input p1a,
  input p1b,
  input p1c,
  input p1d,
  output p1y,
  input p2a,
  input p2b,
  input p2c,
  input p2d,
  output p2y
);

  wire p1_intermediate;
  wire p2_intermediate;

  // First 4-input NAND gate
  assign p1_intermediate = ~(p1a & p1b & p1c & p1d);
  assign p1y = p1_intermediate;

  // Second 4-input NAND gate
  assign p2_intermediate = ~(p2a & p2b & p2c & p2d);
  assign p2y = p2_intermediate;

endmodule