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

  wire and1, and2;  // Intermediate wires for p1y's AND gates
  wire and3, and4;  // Intermediate wires for p2y's AND gates

  assign and1 = p1a & p1b & p1c;
  assign and2 = p1d & p1e & p1f;
  assign p1y = and1 | and2;

  assign and3 = p2a & p2b;
  assign and4 = p2c & p2d;
  assign p2y = and3 | and4;

endmodule