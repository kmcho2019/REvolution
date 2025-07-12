module TopModule(
    input  [3:0] x,
    output       f
);

    // Directly assign the output based on minterms from the K-map:
    // Minterms where f=1:
    // (x3,x2,x1,x0) = (0,0,0,0), (0,0,1,0), (1,1,0,0), (1,1,0,1), (1,1,1,0), (1,0,0,0), (1,0,0,1), (0,1,0,0)
    assign f = (~x[3] & ~x[2] & ~x[1] & ~x[0]) |  // 0000
               (~x[3] & ~x[2] &  x[1] & ~x[0]) |  // 0010
               ( x[3] &  x[2] & ~x[1] & ~x[0]) |  // 1100
               ( x[3] &  x[2] & ~x[1] &  x[0]) |  // 1101
               ( x[3] &  x[2] &  x[1] & ~x[0]) |  // 1110
               ( x[3] & ~x[2] & ~x[1] & ~x[0]) |  // 1000
               ( x[3] & ~x[2] & ~x[1] &  x[0]);   // 1001

endmodule