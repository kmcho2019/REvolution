module TopModule(
    input [3:0] x,
    output f
);

    // Intermediate wires to break down the logic and potentially improve timing
    wire f_1, f_2, f_3;

    // Direct assignment for intermediate wires using simplified logic
    assign f_1 = (~x[2] & ~x[3] & (~x[0] & ~x[1] | x[0] & ~x[1]));
    assign f_2 = (x[2] & x[3] & (~x[0] & ~x[1] | ~x[0] & x[1] | x[0] & x[1]));
    assign f_3 = (x[2] & ~x[3] & (~x[0] & ~x[1] | ~x[0] & x[1] | x[0] & ~x[1]));

    // Final assignment for f using the intermediate wires
    assign f = f_1 | f_2 | f_3;

endmodule