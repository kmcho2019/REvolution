module TopModule(
    input [3:0] x,
    output f
);

    // Intermediate signals for conditions
    wire x2_x3_11, x2_x3_10, x2_x3_00;
    wire x0_x1_00, x0_x1_10;

    assign x2_x3_11 = x[2] & x[3];
    assign x2_x3_10 = x[2] & ~x[3];
    assign x2_x3_00 = ~x[2] & ~x[3];

    assign x0_x1_00 = ~x[0] & ~x[1];
    assign x0_x1_10 = x[0] & ~x[1];

    // Assign f based on conditions
    assign f = x2_x3_11 | 
               (x2_x3_10 & (x0_x1_00 | x0_x1_10)) | 
               (x2_x3_00 & (x0_x1_00 | x0_x1_10));

endmodule