module TopModule (
    input  [5:0] y,
    input        w,
    output       Y1,
    output       Y3
);
    localparam STATE_A = 0;
    localparam STATE_B = 1;
    localparam STATE_C = 2;
    localparam STATE_D = 3;
    localparam STATE_E = 4;
    localparam STATE_F = 5;

    wire w_n = ~w;

    // Y1: from A to B on w=1
    assign Y1 = y[STATE_A] & w;

    // Optimize Y3 logic to reduce OR fan-in:
    // Y3 = w_n & (y[B] | y[C] | y[E] | y[F])
    wire bc_or = y[STATE_B] | y[STATE_C];
    wire ef_or = y[STATE_E] | y[STATE_F];
    assign Y3 = w_n & (bc_or | ef_or);

endmodule