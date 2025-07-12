module TopModule(
    input [3:0] x,
    output f
);

    // Simplified conditions based on Karnaugh map
    wire x2_x3_00 = ~x[2] & ~x[3];
    wire x2_x3_11 = x[2] & x[3];
    wire x2_x3_10 = x[2] & ~x[3];

    wire x0_x1_00 = ~x[0] & ~x[1];
    wire x0_x1_10 = x[0] & ~x[1];

    // Combine conditions to compute f
    assign f = (x2_x3_00 & (x0_x1_00 | x0_x1_10)) |
               (x2_x3_11 & (x0_x1_00 | ~x[0] & x[1] | x[0] & x[1])) |
               (x2_x3_10 & (x0_x1_00 | ~x[0] & x[1] | x0_x1_10));

endmodule