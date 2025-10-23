module TopModule (
    input [5:0] y,
    input w,
    output Y1,
    output Y3
);

    // State definitions for readability
    wire is_A = y[0];
    wire is_B = y[1];
    wire is_C = y[2];
    wire is_D = y[3];
    wire is_E = y[4];
    wire is_F = y[5];

    // Y1: Next state for y[1] (state B)
    // Only transitions from A when w=1
    assign Y1 = is_A & w;

    // Y3: Next state for y[3] (state D)
    // Three possible transitions to D:
    // 1. From B when w=0
    // 2. From C when w=0
    // 3. From F when w=1
    assign Y3 = (is_B & ~w) | (is_C & ~w) | (is_F & w);

endmodule