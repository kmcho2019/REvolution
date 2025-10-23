module TopModule(
    input  [3:0] x,
    output       f
);

    // Intermediate wire for condition when x[2]x[3] = 00
    wire cond_00;
    assign cond_00 = (~x[2] & ~x[3] & (~x[0] & ~x[1] | x[0] & ~x[1]));

    // Intermediate wire for condition when x[2]x[3] = 11
    wire cond_11;
    assign cond_11 = (x[2] & x[3] & (~x[0] | x[1]));

    // Intermediate wire for condition when x[2]x[3] = 10
    wire cond_10;
    assign cond_10 = (x[2] & ~x[3] & (~x[0] & ~x[1] | ~x[0] & x[1] | x[0] & ~x[1]));

    // Final assignment for f using the intermediate wires
    assign f = cond_00 | cond_11 | cond_10;

endmodule