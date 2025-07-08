module TopModule (
  input [4:1] x,
  output logic f
);

  assign f = 
      (~x[3] & x[1] & x[2])       // 1100,1101 group
    | (~x[3] & x[1] & ~x[2])      // 1000,1001 group
    | (~x[3] & ~x[1] & ~x[2])     // 0000,0010 group
    | (x[1] & x[2] & x[3] & x[4]) // 1111 single
    | (x[1] & ~x[2] & x[3] & ~x[4]); // 1010 single

endmodule