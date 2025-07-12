module AndGate(input a, input b, output y);
    assign y = a & b;
endmodule

module OrGate4(input a, input b, input c, input d, output y);
    assign y = a | b | c | d;
endmodule

module NextStateInput(
    input  [5:0] y,
    input        w,
    output       Y1,
    output       Y3
);

    // State bit indices for clarity
    localparam STATE_A = 0;
    localparam STATE_B = 1;
    localparam STATE_C = 2;
    localparam STATE_D = 3;
    localparam STATE_E = 4;
    localparam STATE_F = 5;

    wire w_n = ~w;                 // Invert w once for reuse
    wire or_bcef;                 // OR of y[B], y[C], y[E], y[F]

    // OR gate combining states leading to D on w=0
    OrGate4 or_states(
        .a(y[STATE_B]),
        .b(y[STATE_C]),
        .c(y[STATE_E]),
        .d(y[STATE_F]),
        .y(or_bcef)
    );

    // Y1 = y[A] & w (transition A->B on w=1)
    AndGate and_y1(
        .a(y[STATE_A]),
        .b(w),
        .y(Y1)
    );

    // Y3 = or_bcef & ~w (transitions to D on w=0)
    AndGate and_y3(
        .a(or_bcef),
        .b(w_n),
        .y(Y3)
    );

endmodule

module TopModule (
    input  [5:0] y,
    input        w,
    output       Y1,
    output       Y3
);

    // Instantiate the NextStateInput combinational logic module
    NextStateInput nsi (
        .y(y),
        .w(w),
        .Y1(Y1),
        .Y3(Y3)
    );

endmodule