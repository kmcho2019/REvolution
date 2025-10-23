module TopModule(
    input [3:0] x,
    output f
);

    // Intermediate wires to simplify conditions
    wire x2_x3_00, x2_x3_01, x2_x3_11, x2_x3_10;
    wire x0_x1_00, x0_x1_01, x0_x1_11, x0_x1_10;

    // Assign intermediate wires
    assign x2_x3_00 = ~x[2] & ~x[3];
    assign x2_x3_01 = ~x[2] & x[3];
    assign x2_x3_11 = x[2] & x[3];
    assign x2_x3_10 = x[2] & ~x[3];

    assign x0_x1_00 = ~x[0] & ~x[1];
    assign x0_x1_01 = ~x[0] & x[1];
    assign x0_x1_11 = x[0] & x[1];
    assign x0_x1_10 = x[0] & ~x[1];

    // Final assignment for f using intermediate wires
    assign f = (x2_x3_00 & (x0_x1_00 | x0_x1_10)) |
               (x2_x3_11 & (x0_x1_00 | x0_x1_01 | x0_x1_11)) |
               (x2_x3_10 & (x0_x1_00 | x0_x1_01 | x0_x1_10));

endmodule