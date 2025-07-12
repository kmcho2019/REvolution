module TopModule(
    input  [3:0] x,
    output       f
);

    wire cond_00, cond_11, cond_10;
    wire x00, x01, x11, x10;

    // Define conditions for x[2]x[3]
    assign cond_00 = ~x[2] & ~x[3];
    assign cond_11 = x[2] & x[3];
    assign cond_10 = x[2] & ~x[3];

    // Define conditions for x[0]x[1]
    assign x00 = ~x[0] & ~x[1];
    assign x01 = ~x[0] & x[1];
    assign x11 = x[0] & x[1];
    assign x10 = x[0] & ~x[1];

    // Combine conditions to form the output
    assign f = (cond_00 & (x00 | x10)) |
               (cond_11 & (x00 | x01 | x11)) |
               (cond_10 & (x00 | x01 | x10));

endmodule