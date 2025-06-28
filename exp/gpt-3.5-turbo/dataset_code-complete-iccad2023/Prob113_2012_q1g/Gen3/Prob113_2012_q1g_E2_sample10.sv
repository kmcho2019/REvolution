module TopModule (
  input [4:1] x,
  output logic f
);

// Simplified expression derived from the Karnaugh map
assign f = x[1] & (!x[2] | x[3]) & (x[4] | !x[3]);

endmodule