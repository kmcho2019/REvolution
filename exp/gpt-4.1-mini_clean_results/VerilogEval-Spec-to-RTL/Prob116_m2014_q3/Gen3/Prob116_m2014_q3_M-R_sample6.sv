module TopModule (
    input  [3:0] x,
    output      f
);

// Let rows = {x[3], x[0]}, columns = {x[1], x[2]}
// Positions where f=1 according to K-map:
// row col  f
// 11 00 = x[3]=1,x[0]=1,x[1]=0,x[2]=0  -> f=1
// 11 01 = 1 1 0 1                       -> f=1
// 10 00 = 1 0 0 0                      -> f=1
// 10 01 = 1 0 0 1                      -> f=1
// 01 11 = 0 1 1 1                      -> f=1
// 11 01 = repeated above
// 11 00 and 11 01 already listed

assign f = 
    (x[3] &  x[0] & ~x[1] & ~x[2]) |  // row=11, col=00
    (x[3] &  x[0] & ~x[1] &  x[2]) |  // row=11, col=01
    (x[3] & ~x[0] & ~x[1] & ~x[2]) |  // row=10, col=00
    (x[3] & ~x[0] & ~x[1] &  x[2]) |  // row=10, col=01
    (~x[3] &  x[0] &  x[1] &  x[2]);   // row=01, col=11

endmodule