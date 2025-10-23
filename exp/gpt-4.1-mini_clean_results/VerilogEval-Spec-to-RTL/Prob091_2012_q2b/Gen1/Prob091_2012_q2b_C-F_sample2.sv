module TopModule (
    input  [5:0] y,  // One-hot encoded state: A=y[0], B=y[1], C=y[2], D=y[3], E=y[4], F=y[5]
    input        w,  // Input signal
    output       Y1, // Next input for state B flip-flop (y[1])
    output       Y3  // Next input for state D flip-flop (y[3])
);

    // Y1 corresponds to transition: A -> B on w=1
    // So Y1 = y[0] & w
    assign Y1 = y[0] & w;

    // Y3 corresponds to transitions to D from B, C, D, E, F on w=0
    // So Y3 = (y[1] | y[2] | y[3] | y[4] | y[5]) & ~w
    assign Y3 = (y[1] | y[2] | y[3] | y[4] | y[5]) & (~w);

endmodule