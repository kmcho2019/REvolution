module TopModule (
  input p1a,
  input p1b,
  input p1c,
  input p1d,
  input p1e,
  input p1f,
  output p1y,
  input p2a,
  input p2b,
  input p2c,
  input p2d,
  output p2y
);

  wire and1_p1, and2_p1;
  wire and1_p2, and2_p2;

  assign and1_p1 = p1a & p1b & p1c;
  assign and2_p1 = p1d & p1e & p1f;

  assign and1_p2 = p2a & p2b;
  assign and2_p2 = p2c & p2d;

  assign p1y = and1_p1 | and2_p1;
  assign p2y = and1_p2 | and2_p2;

endmodule