module TopModule (
  input [3:0] x,
  output logic f
);

// Define the binary values for each cell in the Karnaugh map
parameter CELL_00 = 4'b1001;
parameter CELL_01 = 4'b0000;
parameter CELL_11 = 4'b1110;
parameter CELL_10 = 4'b1011;

// Implement the function using logical operations
assign f = 
  // OR operation for minterms with binary 1
  ((x == CELL_00) || (x == CELL_11) || (x == CELL_10)) &&
  // AND operation for inverted minterms with binary 0
  (~(x & CELL_01));

endmodule