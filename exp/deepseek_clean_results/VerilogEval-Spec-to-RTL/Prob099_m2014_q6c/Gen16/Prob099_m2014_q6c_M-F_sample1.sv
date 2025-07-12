module good1 (
    input [5:0] y,  // Current state in one-hot encoding
    input w,       // Input signal
    output Y2,     // Next state y[1] (state B)
    output Y4      // Next state y[3] (state D)
);

    // State definitions (one-hot)
    parameter A = 6'b000001;
    parameter B = 6'b000010;
    parameter C = 6'b000100;
    parameter D = 6'b001000;
    parameter E = 6'b010000;
    parameter F = 6'b100000;

    // Next state logic for Y2 (y[1] - state B)
    assign Y2 = (y == A && ~w);  // Transition to B from A if w=0

    // Next state logic for Y4 (y[3] - state D)
    assign Y4 = (y == A && ~w) ||  // Transition to D from A if w=0 (via B)
                (y == B && w)  ||  // Transition to D from B if w=1
                (y == C && w)  ||  // Transition to D from C if w=1
                (y == E && w)  ||  // Transition to D from E if w=1
                (y == F && w);     // Transition to D from F if w=1

endmodule