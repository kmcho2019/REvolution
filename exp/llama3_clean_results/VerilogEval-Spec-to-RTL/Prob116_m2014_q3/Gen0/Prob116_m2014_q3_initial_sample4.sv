module TopModule(
    input [3:0] x,
    output f
);

assign f = (x[3] & x[2] & ~x[1] & ~x[0]) | // 11xx
           (x[3] & x[2] & x[1] & ~x[0]) | // 1110
           (x[3] & ~x[2] & x[1] & ~x[0]) | // 1010
           (x[3] & ~x[2] & x[1] & x[0]) | // 1011
           (~x[3] & x[2] & x[1] & x[0]); // 0111

endmodule