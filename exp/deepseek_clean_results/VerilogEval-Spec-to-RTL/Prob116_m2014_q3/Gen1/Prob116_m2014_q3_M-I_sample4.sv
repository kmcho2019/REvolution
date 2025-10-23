module TopModule(
    input [3:0] x,  // x[3] = map's x3, x[2:1] = map's x2x1, x[0] = map's x4
    output f
);
    assign f = (x[3] & ~x[1]) | 
               (x[3] & ~x[2] & ~x[0]) | 
               (~x[3] & x[0] & x[2] & x[1]);
endmodule