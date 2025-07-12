module TopModule(
    input [5:0] y,
    input w,
    output Y1,
    output Y3
);

    // Next state logic for Y1 (y[0])
    assign Y1 = (y[0] & w) |   // A -> A when w=1
                (y[3] & w);   // D -> A when w=1

    // Next state logic for Y3 (y[2])
    assign Y3 = (y[1] & ~w) |  // B -> C when w=0
                (y[5] & ~w);   // F -> C when w=0

endmodule