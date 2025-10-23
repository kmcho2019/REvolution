module TopModule(
    input [3:0] x,
    output f
);

    wire x_00, x_11, x_10; // Intermediate signals for conditions related to x[2] and x[3]

    assign x_00 = ~x[2] & ~x[3]; // Condition for x[2]x[3] = 00
    assign x_11 = x[2] & x[3];  // Condition for x[2]x[3] = 11
    assign x_10 = x[2] & ~x[3]; // Condition for x[2]x[3] = 10

    wire x_01, x_11_condition; // Intermediate signals for conditions related to x[0] and x[1]

    assign x_01 = ~x[0] & x[1]; // Condition for x[0]x[1] = 01
    assign x_11_condition = ~x[0] & ~x[1] | x_01 | x[0] & x[1]; // Condition for x[0]x[1] = 00, 01, or 11

    assign f = (x_00 & (~x[0] & ~x[1] | x[0] & ~x[1])) | // Conditions for x[2]x[3] = 00
               (x_11 & x_11_condition) | // Conditions for x[2]x[3] = 11
               (x_10 & (~x[0] & ~x[1] | x_01 | x[0] & ~x[1])); // Conditions for x[2]x[3] = 10

endmodule