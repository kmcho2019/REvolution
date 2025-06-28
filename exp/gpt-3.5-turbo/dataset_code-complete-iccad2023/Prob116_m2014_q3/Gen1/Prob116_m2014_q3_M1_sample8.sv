module TopModule (
  input [4:1] x,
  output logic f
);

  assign f = 
           // Essential input combinations from the Karnaugh map
           (x[3] & !x[2] & !x[1]) |   // x=0110
           (!x[3] &  x[2] & !x[1]) |  // x=0010
           (!x[3] &  x[2] &  x[1]) |  // x=0011
           // Utilizing don't-care values
           (x[3] & !x[2]) |            // d for x=01xx
           (!x[3] & x[1]) |            // d for x=00x0
           (!x[1] & !x[2]);            // d for x=000x

endmodule