module TopModule (
  input [3:0] x,
  output logic f
);

assign f = 
  // Directly using the values from the Karnaugh map table
  // Each 1 represents a minterm that OR together, each 0 is inverted and AND together
  (x == 4'd1 || x == 4'd8 || x == 4'd10 || x == 4'd12);

endmodule