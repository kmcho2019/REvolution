module TopModule (
  input [4:1] x,
  output logic f
);
  // Intermediate signals
  wire not_x2 = ~x[2];
  wire not_x3 = ~x[3];
  wire not_x4 = ~x[4];

  assign f = (not_x3 & not_x4 & (not_x2 | x[1])) |
             (not_x3 & x[4] & x[1]) |
             (x[3] & not_x4 & not_x2) |
             (x[3] & x[4] & x[1] & x[2]);
endmodule