module TopModule (
    input [5:0] y,
    input w,
    output Y2,
    output Y4
);

    // Next state B (Y2) occurs only when in state A and w=0
    assign Y2 = y[0] & ~w;

    // Next state D (Y4) occurs in multiple cases:
    // From B/C/D/E/F when w=1, or from C/E/F when w=0
    assign Y4 = (y[1] & w) |  // From B when w=1
                (y[2] & w) |  // From C when w=1
                (y[3] & ~w) | // From D when w=0
                (y[4] & w) |  // From E when w=1
                (y[5] & w);    // From F when w=1

endmodule