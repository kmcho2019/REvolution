module TopModule (
  input [4:1] x,
  output logic f
);
  
  assign f = 
           !x[3] &  x[2] &  x[1]   |  // x=001x  ->  d
            x[3] & !x[2] & !x[1]  |  // x=0110  ->  0
            x[3] & !x[2] &  x[1]   |  // x=010x  ->  d
            x[3] &  x[2] & !x[1]  |  // x=011x  ->  d
           !x[3] &  x[2] & !x[1]  |  // x=0010  ->  1
           !x[3] & !x[2] &  x[1]  |  // x=000x  ->  d
           !x[3] &  x[2] &  x[1]  |  // x=0011  ->  0
            x[3] &  x[2] &  x[1];    // x=111x  ->  d

endmodule