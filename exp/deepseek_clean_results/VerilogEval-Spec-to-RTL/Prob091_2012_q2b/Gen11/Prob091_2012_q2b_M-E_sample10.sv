module TopModule (
    input [5:0] y,
    input w,
    output Y1,
    output Y3
);

    // Y1: Next state for B (y[1])
    // Only activates when in A state and w=1
    // Priority: Highest (only one source)
    assign Y1 = y[0] & w;

    // Y3: Next state for D (y[3])
    // Activates when:
    // 1. In B state and w=0, OR
    // 2. In C state and w=0, OR
    // 3. In E state and w=0, OR
    // 4. In F state and w=0
    // Implemented via priority encoding where higher states suppress
    assign Y3 = ~w & (y[1] | y[2] | y[4] | y[5]);

endmodule