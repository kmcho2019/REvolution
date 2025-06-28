module TopModule (
  input [4:1] x,
  output logic f
);
  // Define the intermediate signals based on the Karnaugh map
  logic d1, d2, d3, d4, d5, d6, d7, d8;

  // Intermediate signals d1 to d8 representing each cell in the Karnaugh map
  assign d1 = x[1] & ~x[2] & ~x[3] & x[4];
  assign d2 = ~x[1] & ~x[2] & ~x[3] & ~x[4];
  assign d3 = x[1] & x[2] & x[3] & ~x[4];
  assign d4 = x[1] & x[2] & ~x[3] & x[4];
  assign d5 = x[1] & x[2] & x[3] & x[4];
  assign d6 = ~x[1] & ~x[2] & x[3] & ~x[4];
  assign d7 = ~x[1] & ~x[2] & x[3] & x[4];
  assign d8 = x[1] & ~x[2] & ~x[3] & ~x[4];

  // Output logic f based on the combined intermediate signals using OR gate
  assign f = d1 | d2 | d3 | d4 | d5 | d6 | d7 | d8;
endmodule