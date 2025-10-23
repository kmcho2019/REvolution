module NextStateInput (
    input  [5:0] y,
    input        w,
    output       Y1,
    output       Y3
);
    wire w_n = ~w;

    // Y1: next input for y[1] flip-flop (state B)
    assign Y1 = y[0] & w;

    // Y3: next input for y[3] flip-flop (state D)
    // Minimal gate logic from Example 1: Y3 = ~w & ~y[0] & ~y[3]
    assign Y3 = w_n & (~y[0]) & (~y[3]);

endmodule

module TopModule (
    input  [5:0] y,
    input        w,
    output       Y1,
    output       Y3
);

    // Localparams for state indices for clarity
    localparam STATE_A = 0;
    localparam STATE_B = 1;
    localparam STATE_C = 2;
    localparam STATE_D = 3;
    localparam STATE_E = 4;
    localparam STATE_F = 5;

    // Instantiate NextStateInput combinational logic
    NextStateInput ns_input (
        .y(y),
        .w(w),
        .Y1(Y1),
        .Y3(Y3)
    );

endmodule