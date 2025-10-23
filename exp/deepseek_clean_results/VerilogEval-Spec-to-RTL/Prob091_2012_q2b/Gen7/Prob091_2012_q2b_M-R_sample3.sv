module TopModule (
    input [5:0] y,
    input w,
    output Y1,
    output Y3
);

    // Y1: Next state for y[1] (state B)
    // Transition occurs only from A (y[0]) when w=1
    assign Y1 = y[0] & w;

    // Y3: Next state for y[3] (state D)
    // Transition occurs when:
    // 1. In state B (y[1]) and w=0, or
    // 2. In state C (y[2]) and w=0, or
    // 3. In state E (y[4]) and w=0, or
    // 4. In state F (y[5]) and w=0
    assign Y3 = ~w & (y[1] | y[2] | y[4] | y[5]);

endmodule