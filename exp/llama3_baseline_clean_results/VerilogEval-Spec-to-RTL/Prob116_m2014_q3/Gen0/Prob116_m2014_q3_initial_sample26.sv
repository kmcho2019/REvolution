module TopModule(
    input [3:0] x,  // 4-bit input vector
    output f        // 1-bit output
);

assign f = (x[3] & x[1]) | (x[3] & ~x[1] & x[2]) | (~x[3] & x[1] & ~x[2]);

endmodule