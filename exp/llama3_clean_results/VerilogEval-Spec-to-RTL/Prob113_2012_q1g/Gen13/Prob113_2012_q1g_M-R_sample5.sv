module TopModule(
    input [3:0] x,
    output f
);

    wire f_00, f_11, f_10; // Intermediate signals for conditions based on x[2]x[3]

    // Conditions for x[2]x[3] = 00
    assign f_00 = (~x[2] & ~x[3] & (~x[0] & ~x[1] | x[0] & ~x[1]));

    // Conditions for x[2]x[3] = 11
    assign f_11 = (x[2] & x[3] & (~x[0] & ~x[1] | ~x[0] & x[1] | x[0] & x[1]));

    // Conditions for x[2]x[3] = 10
    assign f_10 = (x[2] & ~x[3] & (~x[0] & ~x[1] | ~x[0] & x[1] | x[0] & ~x[1]));

    // Final output
    assign f = f_00 | f_11 | f_10;

endmodule