module TopModule(
    input [5:0] y,
    input w,
    output Y2,
    output Y4
);

    // Next state logic for Y2 (y[2])
    assign Y2 = (y[1] & ~w) |  // B -> C when w=0
                (y[5] & ~w);   // F -> C when w=0

    // Next state logic for Y4 (y[4])
    assign Y4 = (y[2] & ~w) |  // C -> E when w=0
                (y[4] & ~w);   // E -> E when w=0

endmodule