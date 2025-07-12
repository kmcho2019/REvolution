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

    wire w_n = ~w; // Invert w directly

    // Y1 = y[A] & w
    assign Y1 = y[STATE_A] & w;

    // Y3 = (y[B] | y[C] | y[E] | y[F]) & ~w
    assign Y3 = (y[STATE_B] | y[STATE_C] | y[STATE_E] | y[STATE_F]) & w_n;

endmodule