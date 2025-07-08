module TopModule (
  input [4:1] x,
  output logic f
);
  // x[1]=x1, x[2]=x2, x[3]=x3, x[4]=x4

  assign f = (x[1] & ~x[3]) 
          | (x[1] & x[2] & x[3] & x[4]) 
          | (~x[1] & ~x[2] & ~x[4]) 
          | (x[1] & ~x[2] & x[3] & ~x[4]);

endmodule