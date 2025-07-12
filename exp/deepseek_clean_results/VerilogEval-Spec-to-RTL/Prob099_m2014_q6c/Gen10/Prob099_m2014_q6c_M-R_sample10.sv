module TopModule(
    input [5:0] y,
    input w,
    output Y1,
    output Y2,
    output Y3,
    output Y4
);

    // Y1 is active in states E and F (one-hot bits 4 and 5)
    assign Y1 = y[4] | y[5];

    // Y2 is next state for y[1] (state B) - active when moving from A to B
    assign Y2 = y[0] & ~w;

    // Y3 is active when next state will be A or D (as per original)
    assign Y3 = (y[0] & w) |  // A with w=1 stays in A
                (y[1] & w) |  // B with w=1 goes to D
                (y[2] & w) |  // C with w=1 goes to D
                (y[3] & ~w) | // D with w=0 goes to F
                (y[4] & w) |  // E with w=1 goes to D
                (y[5] & w);   // F with w=1 goes to D

    // Y4 is next state for y[3] (state D) - active in transitions to D
    assign Y4 = (y[1] & w) |  // B with w=1 goes to D
                (y[2] & w) |  // C with w=1 goes to D
                (y[4] & w) |  // E with w=1 goes to D
                (y[5] & w);  // F with w=1 goes to D

endmodule