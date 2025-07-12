module TopModule (
    input  [5:0] y,
    input        w,
    output       Y1,
    output       Y3
);

    // Localparams for one-hot state bits
    localparam STATE_A = 0;
    localparam STATE_B = 1;
    localparam STATE_C = 2;
    localparam STATE_D = 3;
    localparam STATE_E = 4;
    localparam STATE_F = 5;

    wire w_n = ~w;

    // Next state input for y[1] (state B) = y[A] & w
    assign Y1 = y[STATE_A] & w;

    // Next state input for y[3] (state D) = ~w & ~y[A] & ~y[D]
    assign Y3 = w_n & (~y[STATE_A]) & (~y[STATE_D]);

endmodule