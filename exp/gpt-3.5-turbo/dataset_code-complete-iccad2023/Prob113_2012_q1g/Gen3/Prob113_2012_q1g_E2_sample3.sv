module TopModule (
  input [3:0] x,
  output logic f
);

  // Implement the function f using simplified logical expression derived from the Karnaugh map
  assign f = x[0] & x[3] | x[1] & !x[2] | x[2] & x[1] & !x[0] | x[3] & !x[1] & !x[2];

endmodule