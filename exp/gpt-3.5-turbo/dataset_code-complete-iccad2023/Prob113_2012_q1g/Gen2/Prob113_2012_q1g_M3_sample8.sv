module TopModule (
  input [4:1] x,
  output logic f
);

assign f = 
  // Directly mapping the binary values from the Karnaugh map table
  // Each 1 represents a minterm that OR together, each 0 is inverted and AND together
  (x == 4'b1011 || x == 4'b1100 || x == 4'b0010 || x == 4'b1001);

endmodule