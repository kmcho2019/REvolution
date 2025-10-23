module TopModule (
    input [5:0] y,    // One-hot encoded state: y[5:0] = FEDCBA
    input w,          // State machine input
    output Y1,        // Next state for y[1] (B)
    output Y3         // Next state for y[3] (D)
);

    // Y1: Transition to B only from A when w=1
    assign Y1 = y[0] & w;

    // Y3: Transition to D from B/C/F when w=0
    assign Y3 = ~w & (y[1] | y[2] | y[5]);

endmodule