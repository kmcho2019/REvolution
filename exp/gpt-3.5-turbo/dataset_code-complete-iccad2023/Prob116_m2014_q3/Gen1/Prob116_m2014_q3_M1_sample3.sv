module TopModule (
  input [4:1] x,
  output logic f
);

  assign f = 
    (x[1] & !x[2] & !x[3] & !x[4]) |  // Cell (01), output 0
    (!x[1] & x[2] & x[3] & !x[4]) |    // Cell (11), output 1
    (x[1] & x[3] & x[4]) |              // Cell (00), output d
    (!x[2] & x[3] & !x[4]);             // Cell (10), output d

endmodule