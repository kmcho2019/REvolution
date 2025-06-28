module TopModule (
  input [4:1] x,
  output logic f
);

// Define the function f by directly mapping the Karnaugh map to logical AND conditions
assign f = 
       (x[4] & !x[3] & x[2] & !x[1]) |   // Entry 1
       (!x[4] & !x[3] & !x[2] & !x[1]) | // Entry 2
       (x[4] & !x[3] & !x[2] & !x[1]) |  // Entry 3
       (x[4] & !x[3] & x[2]& !x[1]) |    // Entry 4
       (x[4] & x[3] & x[2] & !x[1]) |    // Entry 5
       (x[4] & x[3] & !x[2] & !x[1]) |   // Entry 6
       (x[4] & x[3] & x[2] & !x[1]) |    // Entry 7
       (!x[4] & x[3] & x[2] & x[1]);      // Entry 8

endmodule