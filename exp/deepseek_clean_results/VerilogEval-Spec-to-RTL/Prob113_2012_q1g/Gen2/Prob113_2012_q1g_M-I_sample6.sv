module TopModule(
    input [3:0] x,
    output f
);
    assign f = (~x[3] & ~x[2] & (~x[1] & ~x[0] | x[1] & ~x[0])) |  // 0000 or 0010
               (x[3] & x[2] & (~x[1] | ~x[0])) |                   // 1100 or 1101
               (x[3] & ~x[2] & (~x[1] | ~x[0] & x[1]));            // 1000 or 1001 or 1010
endmodule