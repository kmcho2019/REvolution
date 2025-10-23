module TopModule (
    input [5:0] y,  // Current state in one-hot encoding
    input w,       // Input signal
    output Y2,     // Next state y[1] (state B)
    output Y4      // Next state y[3] (state D)
);

    // State bit positions
    localparam A_bit = 0;
    localparam B_bit = 1;
    localparam C_bit = 2;
    localparam D_bit = 3;
    localparam E_bit = 4;
    localparam F_bit = 5;

    // Next state B (Y2) occurs only when in A and w=0
    assign Y2 = y[A_bit] & ~w;

    // Next state D (Y4) occurs in these cases:
    // 1. From A (via B) when w=0
    // 2. From B/C/E/F when w=1
    wire from_BCEF = y[B_bit] | y[C_bit] | y[E_bit] | y[F_bit];
    assign Y4 = (y[A_bit] & ~w) | (from_BCEF & w);

endmodule