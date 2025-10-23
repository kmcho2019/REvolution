module TopModule(
    input [3:0] x,
    output f
);

    // Intermediate wires for conditions
    wire cond_00;  // x[2]x[3] = 00 and (x[0]x[1] = 00 or x[0]x[1] = 10)
    wire cond_11;  // x[2]x[3] = 11 and (x[0]x[1] = 00 or x[0]x[1] = 01 or x[0]x[1] = 11)
    wire cond_10;  // x[2]x[3] = 10 and (x[0]x[1] = 00 or x[0]x[1] = 01 or x[0]x[1] = 10)

    // Assign conditions to intermediate wires
    assign cond_00 = (~x[2] & ~x[3] & (~x[0] & ~x[1] | x[0] & ~x[1]));
    assign cond_11 = (x[2] & x[3] & (~x[0] & ~x[1] | ~x[0] & x[1] | x[0] & x[1]));
    assign cond_10 = (x[2] & ~x[3] & (~x[0] & ~x[1] | ~x[0] & x[1] | x[0] & ~x[1]));

    // Assign f based on conditions
    assign f = cond_00 | cond_11 | cond_10;

endmodule