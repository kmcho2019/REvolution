module TopModule (
  input [4:1] x,
  output logic f
);

assign f = 
  // Directly using the values from the Karnaugh map table
  // Each 1 represents a minterm that ORs together, each 0 is inverted and ANDed together
  (x == 4'b1101 || x == 4'b1000 || x == 4'b1010 || x == 4'b0110);

endmodule