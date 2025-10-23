module NextStateInput(
    input  [5:0] y,
    input        w,
    output       Y1,
    output       Y3
);
    wire w_n = ~w;
    wire y0_or_y3 = y[0] | y[3];
    wire y0_or_y3_n = ~y0_or_y3;

    // Y1: next state input for y[1] (state B)
    // Transition: A (y[0]) --1--> B, so Y1 = y[0] & w
    assign Y1 = y[0] & w;

    // Y3: next state input for y[3] (state D)
    // Transitions to D from B,C,E,F on w=0
    // Simplified as Y3 = (~w) & ~(y[0] | y[3])
    assign Y3 = w_n & y0_or_y3_n;

endmodule

module TopModule(
    input  [5:0] y,
    input        w,
    output       Y1,
    output       Y3
);

    NextStateInput next_state_logic (
        .y(y),
        .w(w),
        .Y1(Y1),
        .Y3(Y3)
    );

endmodule