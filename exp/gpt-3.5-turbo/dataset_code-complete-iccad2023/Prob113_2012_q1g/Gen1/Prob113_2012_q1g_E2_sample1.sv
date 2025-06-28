module TopModule (
  input [4:1] x,
  output logic f
);

// Define f based on the values in the Karnaugh map
assign f = (x == 4'b0010) | (x == 4'b1010) | (x == 4'b1100) | (x == 4'b1101);

endmodule