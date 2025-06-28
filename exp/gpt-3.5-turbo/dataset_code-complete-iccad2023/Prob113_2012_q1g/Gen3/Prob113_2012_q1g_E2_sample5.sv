module TopModule (
  input [4:1] x,
  output logic f
);

// Define the function f by directly using the binary representation of the minterms from the Karnaugh map
assign f = 
  (x == 4'b0010) || (x == 4'b1000) || (x == 4'b1100) || (x == 4'b1010) || (x == 4'b1011);

endmodule