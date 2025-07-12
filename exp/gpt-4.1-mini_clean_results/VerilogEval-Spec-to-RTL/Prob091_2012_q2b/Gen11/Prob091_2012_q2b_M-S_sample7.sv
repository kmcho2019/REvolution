module TopModule (
    input  [5:0] y,
    input        w,
    output       Y1,
    output       Y3
);

    // State bit indices for clarity
    localparam A = 0, B = 1, C = 2, D = 3, E = 4, F = 5;

    wire w_n = ~w;

    // Y1: next input for y[1] flip-flop (state B)
    assign Y1 = y[A] & w;

    // Y3: next input for y[3] flip-flop (state D)
    assign Y3 = w_n & (y[B] | y[C] | y[E] | y[F]);

endmodule