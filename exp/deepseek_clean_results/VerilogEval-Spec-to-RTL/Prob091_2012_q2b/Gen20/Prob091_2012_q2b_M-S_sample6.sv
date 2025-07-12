module TopModule (
    input [5:0] y,    // One-hot state: y[0]=A, y[1]=B, y[2]=C, y[3]=D, y[4]=E, y[5]=F
    input w,          // State machine input
    output Y1,        // Next state for y[1] (B)
    output Y3         // Next state for y[3] (D)
);

    // Y1: Only transitions from A to B when w=1
    assign Y1 = y[0] & w;

    // Y3: Transitions to D from B/C/F when w=0
    assign Y3 = (y[1] | y[2] | y[5]) & ~w;

endmodule