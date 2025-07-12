module TopModule(
    input [5:0] y,
    input w,
    output Y1,
    output Y2,
    output Y3,
    output Y4
);

    // Next state logic for Y1 (y[1]) - state B
    assign Y1 = y[0] & ~w;  // A -> B when w=0

    // Next state logic for Y2 (y[2]) - state C
    assign Y2 = (y[1] & ~w) |  // B -> C when w=0
                (y[5] & ~w);   // F -> C when w=0

    // Next state logic for Y3 (y[3]) - state D
    assign Y3 = (y[1] | y[2] | y[4] | y[5]) & w;  // B/C/E/F -> D when w=1

    // Next state logic for Y4 (y[4]) - state E
    assign Y4 = (y[2] & ~w) |  // C -> E when w=0
                (y[4] & ~w);   // E -> E when w=0

endmodule