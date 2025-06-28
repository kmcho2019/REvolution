module TopModule (
  input [4:1] x,
  output logic f
);

// Simplified expression for f based on the Karnaugh map analysis
assign f = (x[3] & (!x[2] | x[1])) | (x[4] & !x[2]);

endmodule