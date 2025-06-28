module TopModule (
  input [3:0] x,
  output logic f
);

assign f = 
  // Directly using the binary minterms from the Karnaugh map table to assign output values
  (x == 4'b1000 || x == 4'b0001 || x == 4'b1011 || x == 4'b0010 || 
   x == 4'b0110 || x == 4'b0111 || x == 4'b0101 || x == 4'b1100);

endmodule