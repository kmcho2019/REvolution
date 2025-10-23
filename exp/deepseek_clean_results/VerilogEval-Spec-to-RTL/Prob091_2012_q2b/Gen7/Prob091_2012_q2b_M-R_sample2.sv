module TopModule (
    input [5:0] y,
    input w,
    output Y1,
    output Y3
);

    // State definitions (for reference)
    // y[0] = A, y[1] = B, y[2] = C, y[3] = D, y[4] = E, y[5] = F

    // Next state logic for Y1 (y[1] flip-flop input)
    assign Y1 = y[0] & w;  // From state A to B when w=1

    // Next state logic for Y3 (y[3] flip-flop input)
    // Y3 is true when:
    // 1. From B to D when w=0 (y[1] & ~w)
    // 2. From C to D when w=0 (y[2] & ~w)
    // 3. From E to D when w=0 (y[4] & ~w)
    // 4. From F to D when w=0 (y[5] & ~w)
    assign Y3 = ~w & (y[1] | y[2] | y[4] | y[5]);

endmodule