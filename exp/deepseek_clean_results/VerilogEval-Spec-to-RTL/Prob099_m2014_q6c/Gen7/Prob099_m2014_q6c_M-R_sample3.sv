module TopModule(
    input [5:0] y,  // y[0]=A, y[1]=B, y[2]=C, y[3]=D, y[4]=E, y[5]=F
    input w,
    output Y1,      // next y[0] (state A)
    output Y3       // next y[2] (state D)
);

    // Y1: Next state A occurs when:
    // 1. Current state is D and w=0 (D->F is wrong in original, should be D->A when w=1)
    // 2. Current state is A and w=1 (A->A)
    assign Y1 = (y[3] & w) | (y[0] & w);

    // Y3: Next state D occurs when:
    // 1. Current state is B/C/E/F and w=1
    assign Y3 = (y[1] | y[2] | y[4] | y[5]) & w;

endmodule