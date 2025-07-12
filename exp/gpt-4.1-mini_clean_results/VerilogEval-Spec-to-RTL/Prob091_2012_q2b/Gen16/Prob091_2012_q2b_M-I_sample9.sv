module TopModule (
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

    wire w_n = ~w;

    // Y1 = y[A] & w (transition A->B on w=1)
    assign Y1 = y[STATE_A] & w;

    // Y3 = (~w) & (y[B] | y[C] | y[E] | y[F]) (transitions to D on w=0)
    assign Y3 = w_n & (y[STATE_B] | y[STATE_C] | y[STATE_E] | y[STATE_F]);

endmodule