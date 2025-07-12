module TopModule(
    input [5:0] y,
    input w,
    output Y1,
    output Y3
);

    // Y1 represents next state B (y[1] = 1)
    // Only transition from A (y[0]=1) with w=0 leads to B
    assign Y1 = y[0] & ~w;

    // Y3 represents next state D (y[3] = 1)
    // Transitions to D occur from:
    // B (y[1]) with w=1
    // C (y[2]) with w=1
    // D (y[3]) with w=1 (self-loop not shown in description, but included for completeness)
    // E (y[4]) with w=1
    // F (y[5]) with w=1
    assign Y3 = (y[1] | y[2] | y[3] | y[4] | y[5]) & w;

endmodule