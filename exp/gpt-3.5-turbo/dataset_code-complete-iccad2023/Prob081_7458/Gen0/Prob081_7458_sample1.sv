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

  wire p1y_intermediate_1, p1y_intermediate_2;
  wire p2y_intermediate_1, p2y_intermediate_2;

  assign p1y_intermediate_1 = p1a & p1b & p1c;
  assign p1y_intermediate_2 = p1d & p1e & p1f;

  assign p2y_intermediate_1 = p2a & p2b;
  assign p2y_intermediate_2 = p2c & p2d;

  assign p1y = p1y_intermediate_1 | p1y_intermediate_2;
  assign p2y = p2y_intermediate_1 | p2y_intermediate_2;

endmodule