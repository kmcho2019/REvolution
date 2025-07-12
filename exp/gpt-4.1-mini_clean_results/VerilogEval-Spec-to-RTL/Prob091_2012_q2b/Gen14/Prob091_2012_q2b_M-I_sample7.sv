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

    wire w_n = ~w;

    // Balanced OR tree for Y3 input logic: (y[B] | y[C]) and (y[E] | y[F]) then ORed
    wire or1 = y[STATE_B] | y[STATE_C];
    wire or2 = y[STATE_E] | y[STATE_F];
    wire or_all = or1 | or2;

    // Y1: input to y[1] flip-flop (state B)
    assign Y1 = y[STATE_A] & w;

    // Y3: input to y[3] flip-flop (state D)
    assign Y3 = w_n & or_all;

endmodule