module TopModule(
    input [3:0] x,
    output f
);

    // Direct assignment for f using simplified logic
    assign f = (~x[2] & ~x[3] & (~x[0] & ~x[1] | x[0] & ~x[1])) |
               (x[2] & x[3] & (~x[0] & ~x[1] | ~x[0] & x[1] | x[0] & x[1])) |
               (x[2] & ~x[3] & (~x[0] & ~x[1] | ~x[0] & x[1] | x[0] & ~x[1]));

endmodule