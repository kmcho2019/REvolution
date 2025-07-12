module TopModule(
    input [3:0] x,
    output f
);
    assign f = (~x[3] & ~x[2] & ((~x[1] & ~x[0]) | (x[1] & ~x[0]))) |  // Covers 0000 and 0010
               (x[3] & x[2]) |                                         // Covers all 11xx cases
               (x[3] & ~x[2] & (~x[1] | ~x[0]));                       // Covers 1000,1001,1010
endmodule