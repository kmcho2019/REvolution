module TopModule(
    input [3:0] x,
    output f
);

    // Simplified implementation of conditions
    assign f = (~x[2] & ~x[3] & (~x[0] & ~x[1] | x[0] & ~x[1])) |
               (x[2] & (x[3] | ~x[3]) & (~x[0] & ~x[1] | x[0] & ~x[1] | ~x[0] & x[1])) |
               (~x[2] & x[3] & (~x[0] & ~x[1] | x[0] & ~x[1]));

endmodule