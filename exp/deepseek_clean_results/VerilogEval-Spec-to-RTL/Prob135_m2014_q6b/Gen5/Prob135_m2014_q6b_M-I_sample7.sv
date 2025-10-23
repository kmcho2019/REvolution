module TopModule (
    input [2:0] y,    // Current state (3-bit input)
    input w,          // Input signal
    output Y1         // Output y[1]
);

// State encoding parameters
localparam A = 3'b000;
localparam B = 3'b001;
localparam C = 3'b010;
localparam D = 3'b011;
localparam E = 3'b100;
localparam F = 3'b101;

// Next-state logic for y[1] only
assign Y1 = (y == A) ? 1'b0 :         // A->B or A->A: y[1] stays 0
            (y == B) ? w :             // B->D (1) or B->C (0)
            (y == C) ? w :             // C->D (1) or C->E (0)
            (y == D) ? ~w :            // D->A (0) or D->F (1)
            (y == E) ? 1'b1 :          // E->D or E->E: y[1] stays 1
            (y == F) ? 1'b1;           // F->D (1) or F->C (1) - corrected

endmodule