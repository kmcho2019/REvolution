module TopModule (
    input [5:0] y,  // One-hot state: y[0]=A, y[1]=B, y[2]=C, y[3]=D, y[4]=E, y[5]=F
    input w,        // State machine input
    output Y1,      // Next state for y[1] (B)
    output Y3       // Next state for y[3] (D)
);

    // Y1: Only set when in state A (y[0]) and w=1
    assign Y1 = y[0] & w;

    // Y3: Set when in states B,C,E,F and w=0
    assign Y3 = (y[1] | y[2] | y[4] | y[5]) & ~w;
endmodule