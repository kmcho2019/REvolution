module NextStateInput (
    input  [5:0] y,
    input        w,
    output       Y1,
    output       Y3
);
    wire w_n = ~w;

    // Y1: input to y[1] flip-flop (state B)
    assign Y1 = y[0] & w;

    // Y3: input to y[3] flip-flop (state D)
    // Asserted when w=0 and current state is B, C, E, or F
    assign Y3 = w_n & (y[1] | y[2] | y[4] | y[5]);

endmodule

module TopModule (
    input  [5:0] y,
    input        w,
    output       Y1,
    output       Y3
);

    // Localparams for state bit indices
    localparam STATE_A = 0;
    localparam STATE_B = 1;
    localparam STATE_C = 2;
    localparam STATE_D = 3;
    localparam STATE_E = 4;
    localparam STATE_F = 5;

    // Instantiate combinational logic for next state inputs
    NextStateInput ns_input (
        .y(y),
        .w(w),
        .Y1(Y1),
        .Y3(Y3)
    );

endmodule