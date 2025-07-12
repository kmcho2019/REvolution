module TopModule (
    input [5:0] y,
    input w,
    output Y1,
    output Y3
);

    // Y1 is the input to y[1] flip-flop (next state for B)
    // From state diagram: A--1-->B, so Y1 = y[0] & w
    assign Y1 = y[0] & w;

    // Y3 is the input to y[3] flip-flop (next state for D)
    // From state diagram: transitions to D occur when:
    // B--0-->D, C--0-->D, E--0-->D, F--0-->D
    // Which translates to: (~w & (y[1] | y[2] | y[4] | y[5]))
    // But can be optimized using one-hot property to:
    assign Y3 = ~w & ~(y[0] | y[3]);

endmodule