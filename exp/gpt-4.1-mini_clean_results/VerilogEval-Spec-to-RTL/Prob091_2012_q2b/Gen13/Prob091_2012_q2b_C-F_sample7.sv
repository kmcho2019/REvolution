module NextStateInput(
    input  [5:0] y,
    input        w,
    output       Y1,
    output       Y3
);
    wire w_n = ~w;

    // Y1: next state input for state B (y[1])
    // Only transition to B: A --1--> B, i.e., y[0] & w
    assign Y1 = y[0] & w;

    // Y3: next state input for state D (y[3])
    // Transitions to D occur from B,C,E,F on w=0:
    // Y3 = ~w & (y[1] | y[2] | y[4] | y[5])
    // This is equivalent to ~w & ~(y[0] | y[3]) since one-hot encoding means only one bit set
    assign Y3 = w_n & ~(y[0] | y[3]);

endmodule

module TopModule(
    input  [5:0] y,
    input        w,
    output       Y1,
    output       Y3
);

    // Instantiate next state input logic module for modular clarity
    NextStateInput next_state_inst (
        .y(y),
        .w(w),
        .Y1(Y1),
        .Y3(Y3)
    );

endmodule