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

  wire nand_input1, nand_input2;

  assign nand_input1 = ~(p1a & p1b & p1c & p1d);
  assign nand_input2 = ~(p2a & p2b & p2c & p2d);

  assign p1y = nand_input1;
  assign p2y = nand_input2;

endmodule