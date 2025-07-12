module TopModule (
    input [5:0] y,  // Current state in one-hot encoding
    input w,       // Input signal
    output Y1,     // Next state y[0] (state A)
    output Y3      // Next state y[2] (state C)
);

    // State definitions (one-hot)
    parameter A = 6'b000001;
    parameter B = 6'b000010;
    parameter C = 6'b000100;
    parameter D = 6'b001000;
    parameter E = 6'b010000;
    parameter F = 6'b100000;

    // Next state logic for Y1 (y[0] - state A)
    assign Y1 = (y == A && w) ||  // Stay in A if w=1
                (y == D && w);    // Return to A from D if w=1

    // Next state logic for Y3 (y[2] - state C)
    assign Y3 = (y == B && ~w) ||  // Move to C from B if w=0
                (y == F && ~w);    // Move to C from F if w=0

endmodule