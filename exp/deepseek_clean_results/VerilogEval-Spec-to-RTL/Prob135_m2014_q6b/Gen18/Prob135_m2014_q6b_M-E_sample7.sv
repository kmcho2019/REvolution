module TopModule (
    input [2:0] y,
    input w,
    output Y1
);

    assign Y1 = y[1];

    // Next-state logic for y[1] using Boolean equations
    wire next_y1;
    assign next_y1 = 
        // Transitions that set y[1] to 1:
        (y == 3'b001 && w)  ||  // B->D
        (y == 3'b010 && w)  ||  // C->D
        (y == 3'b011 && ~w) ||  // D->F
        (y == 3'b100)       ||  // E->E or E->D
        (y == 3'b101)       ||  // F->C or F->D (both set y[1]=1)
        // All other transitions keep y[1]=0
        // No need to explicitly list them as they're covered by default 0

        // Special case for F->C transition (y=101,w=0)
        // Already covered by (y == 3'b101) term
        1'b0; // Default case (should never occur with proper state encoding)

endmodule