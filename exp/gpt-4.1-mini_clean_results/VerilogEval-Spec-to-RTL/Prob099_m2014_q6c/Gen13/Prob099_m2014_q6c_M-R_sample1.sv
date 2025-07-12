module TopModule (
    input  [5:0] y,   // one-hot current states: A=y[0], B=y[1], C=y[2], D=y[3], E=y[4], F=y[5]
    input        w,
    output       Y2,  // next state B (y[1])
    output       Y4   // next state D (y[3])
);

    // Next state B (y[1]) occurs only from state A with w=0
    // From A: if w=0 -> B
    assign Y2 = y[0] & ~w;

    // Next state D (y[3]) occurs from several transitions:
    // From B: if w=1 -> D
    // From C: if w=1 -> D
    // From E: if w=1 -> D
    // From F: if w=1 -> D
    assign Y4 = (y[1] | y[2] | y[4] | y[5]) & w;

endmodule