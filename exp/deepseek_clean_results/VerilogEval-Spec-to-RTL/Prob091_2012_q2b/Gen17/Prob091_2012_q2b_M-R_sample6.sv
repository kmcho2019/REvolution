module TopModule (
    input [5:0] y,    // One-hot encoded state: y[5:0] = FEDCBA
    input w,          // State machine input
    output reg Y1,    // Next state for y[1] (B) - from A when w=1
    output reg Y3     // Next state for y[3] (D) - from B/C/F when w=0
);

    // State encoding (one-hot):
    // y[0] = 000001 = A
    // y[1] = 000010 = B
    // y[2] = 000100 = C
    // y[3] = 001000 = D
    // y[4] = 010000 = E
    // y[5] = 100000 = F

    always_comb begin
        // Y1 logic: Transition to B (y[1]) occurs only from A (y[0]) when w=1
        Y1 = y[0] & w;

        // Y3 logic: Transition to D (y[3]) occurs when:
        // 1. Current state is B (y[1]) or C (y[2]) or F (y[5])
        // 2. Input w is 0
        // Using one-hot property: only one y bit can be active at a time
        Y3 = ~w & (y[1] | y[2] | y[5]);
    end

endmodule