module TopModule (
    input [5:0] y,
    input w,
    output Y1,
    output Y2,
    output Y3,
    output Y4
);

    // Y1 represents next state B (y[1] = 1)
    assign Y1 = y[0] & ~w;  // From state A (y[0]) when w=0

    // Y2 represents next state C (y[2] = 1)
    assign Y2 = (y[1] | y[5]) & ~w; // From states B or F when w=0

    // Y3 represents next state D (y[3] = 1)
    assign Y3 = (y[1] | y[2] | y[3] | y[4] | y[5]) & w;
    // From states B,C,D,E,F when w=1

    // Y4 represents next state E (y[4] = 1)
    assign Y4 = (y[2] | y[4]) & ~w; // From states C or E when w=0

endmodule