module TopModule(
  input [4:1] x,
  output logic f
);

// Define the minterms based on the Karnaugh map binary combinations
// Minterms: 1, 4, 8, 10, 12
assign f = (x == 4'b0001 || x == 4'b0100 || x == 4'b1000 || x == 4'b1010 || x == 4'b1100);

endmodule