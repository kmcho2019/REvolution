module TopModule (
    input [5:0] y, // current state
    input w,       // input signal
    output Y1,     // input of state flip-flop y[1]
    output Y3      // input of state flip-flop y[3]
);

    // Define states for clarity
    wire is_A = ~y[5] & ~y[4] & ~y[3] & ~y[2] & ~y[1] & y[0];
    wire is_B = ~y[5] & ~y[4] & ~y[3] & ~y[2] & y[1] & ~y[0];
    wire is_C = ~y[5] & ~y[4] & ~y[3] & y[2] & ~y[1] & ~y[0];
    wire is_D = ~y[5] & ~y[4] & y[3] & ~y[2] & ~y[1] & ~y[0];
    wire is_E = ~y[5] & y[4] & ~y[3] & ~y[2] & ~y[1] & ~y[0];
    wire is_F = y[5] & ~y[4] & ~y[3] & ~y[2] & ~y[1] & ~y[0];

    // Assign Y1 based on transition to state B
    assign Y1 = is_A & w;

    // Assign Y3 based on transitions to state D
    assign Y3 = (is_B | is_C | is_E | is_D | is_F) & ~w;

endmodule