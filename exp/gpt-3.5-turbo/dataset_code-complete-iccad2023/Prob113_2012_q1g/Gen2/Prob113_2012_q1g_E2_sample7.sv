module TopModule (
  input [3:0] x,
  output logic f
);

assign f = 
  // Bitwise operations to match the binary representations of minterms in the Karnaugh map
  (x & 4'b1011) | (~x & 4'b1001) | (x & 4'b0110) | (~x & 4'b0100);

endmodule