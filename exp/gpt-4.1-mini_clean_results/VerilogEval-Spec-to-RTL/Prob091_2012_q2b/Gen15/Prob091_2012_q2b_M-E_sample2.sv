module TopModule (
    input  [5:0] y,
    input        w,
    output       Y1,
    output       Y3
);

    // Define localparams for state bit indices for clarity
    localparam A = 0;
    localparam B = 1;
    localparam C = 2;
    localparam D = 3;
    localparam E = 4;
    localparam F = 5;

    // Output Y1 is the input to flip-flop y[1], which is state B
    // Y1 = y[A] & w
    assign Y1 = y[A] & w;

    // Output Y3 is the input to flip-flop y[3], which is state D
    // Y3 = (y[B] | y[C] | y[E] | y[F]) & ~w
    assign Y3 = (y[B] | y[C] | y[E] | y[F]) & ~w;

endmodule