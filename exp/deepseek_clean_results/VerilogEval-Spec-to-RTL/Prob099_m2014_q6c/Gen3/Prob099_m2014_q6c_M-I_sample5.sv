module TopModule(
    input [5:0] y,
    input w,
    output Y1,
    output Y3
);

    // Next state logic for Y1 (y[1]) - state B
    assign Y1 = y[0] & ~w;  // A -> B when w=0

    // Next state logic for Y3 (y[3]) - state D
    assign Y3 = (y[1] & w) |  // B -> D when w=1
                (y[2] & w) |  // C -> D when w=1
                (y[4] & w) |  // E -> D when w=1
                (y[5] & w);   // F -> D when w=1

endmodule