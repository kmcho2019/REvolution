module TopModule(
    input  [5:0] y,   // one-hot current state encoding: A=y[0], B=y[1], C=y[2], D=y[3], E=y[4], F=y[5]
    input        w,
    output       Y1,  // next state bit for B (y[1])
    output       Y3   // next state bit for D (y[3])
);

    // State definitions for readability
    localparam A_bit = 0;
    localparam B_bit = 1;
    localparam C_bit = 2;
    localparam D_bit = 3;
    localparam E_bit = 4;
    localparam F_bit = 5;

    wire A = y[A_bit];
    wire B = y[B_bit];
    wire C = y[C_bit];
    wire D = y[D_bit];
    wire E = y[E_bit];
    wire F = y[F_bit];

    wire w_bar = ~w;

    // Next state B (Y1) is active when current state is A and input w=0
    assign Y1 = A & w_bar;

    // Next state D (Y3) is active when w=1 and current state is B, C, E, or F
    // Group terms for minimal logic: 
    // Y3 = w & (B | C | E | F)
    wire BC = B | C;
    wire EF = E | F;
    assign Y3 = w & (BC | EF);

endmodule