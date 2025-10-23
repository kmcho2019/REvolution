module TopModule (
    input [5:0] y,  // Current state in one-hot encoding (A=000001, B=000010, etc.)
    input w,       // Input signal
    output Y1,     // Next state y[1] (B)
    output Y3      // Next state y[3] (D)
);

    // Y1 is active when in state A (y[0]) and w=0 (transition to B)
    assign Y1 = y[0] & ~w;

    // Y3 is active when in any state except A (y[1] to y[5]) and w=1
    assign Y3 = |y[5:1] & w;

endmodule