module NextStateInput (
    input  [5:0] y,
    input        w,
    output       Y1,
    output       Y3
);
    // Localparams for state bits to aid readability and maintenance
    localparam STATE_A = 0;
    localparam STATE_B = 1;
    localparam STATE_C = 2;
    localparam STATE_D = 3;
    localparam STATE_E = 4;
    localparam STATE_F = 5;

    wire w_n = ~w;

    // Next state input Y1 (input to flip-flop y[1], state B)
    // Transitions to B:
    //   A (y[0]) -- w=1 --> B (y[1])
    assign Y1 = y[STATE_A] & w;

    // Next state input Y3 (input to flip-flop y[3], state D)
    // Transitions to D:
    //   B (y[1]) -- w=0 --> D (y[3])
    //   C (y[2]) -- w=0 --> D (y[3])
    //   E (y[4]) -- w=0 --> D (y[3])
    //   F (y[5]) -- w=0 --> D (y[3])
    assign Y3 = w_n & (y[STATE_B] | y[STATE_C] | y[STATE_E] | y[STATE_F]);

endmodule

module TopModule (
    input  [5:0] y,
    input        w,
    output       Y1,
    output       Y3
);
    // Localparams for state bits (optional but consistent for top-level reference)
    localparam STATE_A = 0;
    localparam STATE_B = 1;
    localparam STATE_C = 2;
    localparam STATE_D = 3;
    localparam STATE_E = 4;
    localparam STATE_F = 5;

    // Instantiate combinational logic module that derives next state inputs
    NextStateInput next_state_inst (
        .y(y),
        .w(w),
        .Y1(Y1),
        .Y3(Y3)
    );
endmodule