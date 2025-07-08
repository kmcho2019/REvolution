module TopModule (
    input [5:0] y,
    input w,
    output Y1,
    output Y3
);

    // Y1 is active when in state A (y[0]) and w is 0
    assign Y1 = y[0] & ~w;

    // Y3 is active when:
    // 1. In state B (y[1]) and w is 1, or
    // 2. In state C (y[2]) and w is 1, or
    // 3. In state E (y[4]) and w is 1, or
    // 4. In state F (y[5]) and w is 1
    assign Y3 = (y[1] & w) | (y[2] & w) | (y[4] & w) | (y[5] & w);

endmodule