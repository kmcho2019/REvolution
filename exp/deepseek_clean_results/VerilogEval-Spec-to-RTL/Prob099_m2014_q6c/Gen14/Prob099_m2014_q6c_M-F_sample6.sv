module TopModule (
    input [5:0] y,  // One-hot encoded current state
    input w,        // Input signal
    output Y1,      // Next state B (y[1])
    output Y3       // Next state D (y[3])
);

    // State definitions (one-hot)
    parameter A = 6'b000001;
    parameter B = 6'b000010;
    parameter C = 6'b000100;
    parameter D = 6'b001000;
    parameter E = 6'b010000;
    parameter F = 6'b100000;

    // Next state logic for Y1 (B) and Y3 (D)
    assign Y1 = (y == A && ~w) ||           // A->B transition
                (y == F && ~w && ~w);       // F->C would not affect Y1, included for completeness

    assign Y3 = (y == A && w) ||            // A->A doesn't affect Y3, but included for pattern
                (y == B && w) ||            // B->D
                (y == C && w) ||            // C->D
                (y == D && w) ||            // D->A doesn't affect Y3
                (y == E && w) ||            // E->D
                (y == F && w);              // F->D

endmodule