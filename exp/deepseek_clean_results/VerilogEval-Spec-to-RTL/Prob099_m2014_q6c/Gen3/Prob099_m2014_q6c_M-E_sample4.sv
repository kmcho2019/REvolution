module TopModule (
    input [5:0] y,
    input w,
    output Y1,
    output Y3
);

    // Y1 is next state B (y[1]) - only transitions from A (y[0]) when w=0
    assign Y1 = ~w & y[0];

    // Y3 is next state D (y[3]) - transitions from:
    // B (y[1]) when w=1
    // C (y[2]) when w=1
    // D (y[3]) when w=1 (but D transitions to F/A)
    // E (y[4]) when w=1
    // F (y[5]) when w=1
    // Simplified to: any non-A state when w=1
    assign Y3 = w & |y[5:1];

endmodule