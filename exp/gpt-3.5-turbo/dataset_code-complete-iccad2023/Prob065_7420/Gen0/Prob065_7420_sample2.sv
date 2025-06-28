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

  wire nand1_out, nand2_out;

  // First 4-input NAND gate
  nand gate1 (
    .a(p1a),
    .b(p1b),
    .c(p1c),
    .d(p1d),
    .y(nand1_out)
  );

  // Second 4-input NAND gate
  nand gate2 (
    .a(p2a),
    .b(p2b),
    .c(p2c),
    .d(p2d),
    .y(nand2_out)
  );

  // Output assignments
  assign p1y = nand1_out;
  assign p2y = nand2_out;

endmodule

module nand (
  input a,
  input b,
  input c,
  input d,
  output y
);
  
  wire not_ab, not_cd, nand_out;

  // Implementing 4-input NAND gate using cascaded 2-input NAND gates
  assign not_ab = ~(a & b);
  assign not_cd = ~(c & d);
  assign nand_out = ~(not_ab & not_cd);
  assign y = nand_out;

endmodule