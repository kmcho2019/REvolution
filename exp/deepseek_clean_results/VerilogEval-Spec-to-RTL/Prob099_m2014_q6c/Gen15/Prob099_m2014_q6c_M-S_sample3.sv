module TopModule (
    input [5:0] y,  // Current state in one-hot (A=y[0], B=y[1],..., F=y[5])
    input w,        // Input signal
    output Y1,      // Next state y[1] (state B)
    output Y3       // Next state y[3] (state D)
);

    // Y1 is only set when transitioning from A (y[0]) to B with w=0
    assign Y1 = y[0] & ~w;

    // Y3 is set when transitioning from B,C,E,F to D with w=1
    assign Y3 = (y[1] | y[2] | y[4] | y[5]) & w;

endmodule