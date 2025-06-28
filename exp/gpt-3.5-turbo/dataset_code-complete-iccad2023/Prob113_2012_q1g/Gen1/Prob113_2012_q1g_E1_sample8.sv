module TopModule (
  input [4:1] x,
  output logic f
);

  // Define the intermediate signals based on the identified groups in the Karnaugh map
  logic group1, group2, group3, group4;

  // Group 1: Cells (00) and (01)
  assign group1 = x[3] & ~x[4];
  // Group 2: Cells (11) and (10)
  assign group2 = x[1] & ~x[2];
  // Group 3: Cells (11), (10), and (01)
  assign group3 = ~x[1] & ~x[2] & x[3];
  // Group 4: Cell (00)
  assign group4 = x[4];

  // Output logic f based on the combined groups using OR gate
  assign f = group1 | group2 | group3 | group4;

endmodule