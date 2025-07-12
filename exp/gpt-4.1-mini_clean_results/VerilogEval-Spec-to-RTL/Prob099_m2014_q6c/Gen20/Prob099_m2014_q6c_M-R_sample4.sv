module TopModule(
    input  [5:0] y,  // current state one-hot: A=y[0], B=y[1], C=y[2], D=y[3], E=y[4], F=y[5]
    input        w,
    output       Y2, // next state bit for B (y[1])
    output       Y4  // next state bit for D (y[3])
);

    // Intermediate signals for state groups
    wire state_A = y[0];
    wire state_B = y[1];
    wire state_C = y[2];
    wire state_D = y[3];
    wire state_E = y[4];
    wire state_F = y[5];

    wire from_ABCDEF_w1 = state_B | state_C | state_E | state_F;

    // Next state B: from A when w=0
    assign Y2 = state_A & (~w);

    // Next state D: from B,C,E,F when w=1
    assign Y4 = w & from_ABCDEF_w1;

endmodule