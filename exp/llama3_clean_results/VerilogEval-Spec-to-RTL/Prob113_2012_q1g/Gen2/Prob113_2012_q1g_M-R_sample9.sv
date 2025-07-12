module TopModule(
    input  [3:0] x,
    output       f
);

    wire x02, x12, x03, x13;

    assign x02 = ~x[2] & ~x[3];
    assign x12 = x[2] & x[3];
    assign x03 = x[2] & ~x[3];
    assign x13 = ~x[2] & x[3];

    assign f = (x02 & (~x[0] & ~x[1] | x[0] & ~x[1])) |
               (x12 & (~x[0] & ~x[1] | ~x[0] & x[1] | x[0] & x[1])) |
               (x03 & (~x[0] & ~x[1] | ~x[0] & x[1] | x[0] & ~x[1]));

endmodule