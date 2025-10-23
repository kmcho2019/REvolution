module TopModule (
    input  [5:0] y,   // One-hot current state: y[0]=A,..., y[5]=F
    input        w,
    output       Y1,  // Next-state bit for B (y[1])
    output       Y3   // Next-state bit for D (y[3])
);

    // y[0]=A, y[1]=B, y[2]=C, y[3]=D, y[4]=E, y[5]=F

    // Next state B (y[1]) occurs only from:
    // From A if w=0: y[0]&~w
    // No other transitions lead to B
    assign Y1 = y[0] & ~w;

    // Next state D (y[3]) occurs from:
    // B if w=1: y[1]&w
    // C if w=1: y[2]&w
    // E if w=1: y[4]&w
    // F if w=1: y[5]&w
    assign Y3 = (y[1] | y[2] | y[4] | y[5]) & w;

endmodule