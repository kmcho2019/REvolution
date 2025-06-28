module TopModule (
  input [4:1] x,
  output logic f
);

// Simplified expression for f based on the Karnaugh map, considering don't-care values
assign f = (x[2] & !x[3]) | (x[1] & (x[3] ^ x[4]));

endmodule