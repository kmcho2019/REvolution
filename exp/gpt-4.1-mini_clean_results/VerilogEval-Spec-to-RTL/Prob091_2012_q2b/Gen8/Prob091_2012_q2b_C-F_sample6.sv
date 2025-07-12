module NextStateInput(
    input  [5:0] y,
    input        w,
    output       Y1,
    output       Y3
);
    wire w_n = ~w;

    // Next state input logic for y[1] (state B)
    // Only transition to B: from A(0) on w=1
    assign Y1 = y[0] & w;

    // Next state input logic for y[3] (state D)
    // Transitions to D from B, C, E, F on w=0
    assign Y3 = w_n & (y[1] | y[2] | y[4] | y[5]);

endmodule

module TopModule(
    input  [5:0] y,
    input        w,
    output       Y1,
    output       Y3
);

    // Instantiate the combinational logic for next state inputs
    NextStateInput next_state_input (
        .y(y),
        .w(w),
        .Y1(Y1),
        .Y3(Y3)
    );

endmodule