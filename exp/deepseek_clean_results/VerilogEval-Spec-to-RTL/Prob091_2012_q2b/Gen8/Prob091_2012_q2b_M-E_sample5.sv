module TopModule (
    input [5:0] y,
    input w,
    output Y1,
    output Y3
);

    // Y1: Next state for y[1] (state B)
    // Only set when in state A (y[0]) and w is high
    assign Y1 = y[0] & w;

    // Y3: Next state for y[3] (state D)
    // Implemented using priority transition concept:
    // D is the target unless we're in states that don't transition to D (A or D)
    // or when w=1 (except for specific cases)
    wire not_from_AD = ~(y[0] | y[3]);
    wire from_E_with_w0 = y[4] & ~w;
    wire from_F_with_w0 = y[5] & ~w;
    
    assign Y3 = (not_from_AD | from_E_with_w0 | from_F_with_w0) & ~w;

endmodule