module AndGate(input a, input b, output y);
    assign y = a & b;
endmodule

module OrGate4(input a, input b, input c, input d, output y);
    assign y = a | b | c | d;
endmodule

module TopModule (
    input  [5:0] y,
    input        w,
    output       Y1,
    output       Y3
);

    // Localparams for state bits for readability
    localparam STATE_A = 0;
    localparam STATE_B = 1;
    localparam STATE_C = 2;
    localparam STATE_D = 3;
    localparam STATE_E = 4;
    localparam STATE_F = 5;

    wire w_n = ~w;            // Invert w (direct assign, no gate instantiation)
    wire or_states_for_D;     // OR of y[B], y[C], y[E], y[F]

    // OR gate for states leading to D on w=0
    OrGate4 or_d(
        .a(y[STATE_B]),
        .b(y[STATE_C]),
        .c(y[STATE_E]),
        .d(y[STATE_F]),
        .y(or_states_for_D)
    );

    // AND gate for Y1 = y[A] & w
    AndGate and_y1(
        .a(y[STATE_A]),
        .b(w),
        .y(Y1)
    );

    // AND gate for Y3 = (y[B] | y[C] | y[E] | y[F]) & ~w
    AndGate and_y3(
        .a(or_states_for_D),
        .b(w_n),
        .y(Y3)
    );

endmodule