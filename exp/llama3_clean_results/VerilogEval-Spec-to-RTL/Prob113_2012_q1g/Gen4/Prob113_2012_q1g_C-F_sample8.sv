module TopModule(
    input [3:0] x,
    output f
);

    wire x_00, x_11, x_10; // Intermediate signals for conditions related to x[2] and x[3]

    assign x_00 = ~x[2] & ~x[3]; // Condition for x[2]x[3] = 00
    assign x_11 = x[2] & x[3];  // Condition for x[2]x[3] = 11
    assign x_10 = x[2] & ~x[3]; // Condition for x[2]x[3] = 10

    assign f = (x_00 & (~x[0] & ~x[1] | x[0] & ~x[1])) | // Conditions for x[2]x[3] = 00
               (x_11 & (~x[0] & ~x[1] | ~x[0] & x[1] | x[0] & x[1])) | // Conditions for x[2]x[3] = 11
               (x_10 & (~x[0] & ~x[1] | ~x[0] & x[1] | x[0] & ~x[1])); // Conditions for x[2]x[3] = 10

endmodule