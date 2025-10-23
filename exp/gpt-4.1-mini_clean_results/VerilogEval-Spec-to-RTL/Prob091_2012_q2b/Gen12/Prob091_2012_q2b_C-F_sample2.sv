module TopModule (
    input  [5:0] y,
    input        w,
    output       Y1,
    output       Y3
);
    // Localparams for state bits (one-hot encoding)
    localparam STATE_A = 0;
    localparam STATE_B = 1;
    localparam STATE_C = 2;
    localparam STATE_D = 3;
    localparam STATE_E = 4;
    localparam STATE_F = 5;

    wire w_n = ~w;

    // Y1 = y[A] & w
    assign Y1 = y[STATE_A] & w;

    // Y3 = ~w & ~(y[A] | y[D])
    // This covers transitions to D from B, C, E, and F since one-hot states only one bit set
    assign Y3 = w_n & ~(y[STATE_A] | y[STATE_D]);

endmodule