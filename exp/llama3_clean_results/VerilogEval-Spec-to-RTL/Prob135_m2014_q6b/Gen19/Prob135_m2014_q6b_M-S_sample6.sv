module TopModule(
    input [2:0] y,
    input w,
    output Y1
);

    // Simplify the logic for y[1] by directly computing it based on the current state (y) and input (w).
    // For y[1] to be 1 in the next state, the current state must be either B, D, E, or F, and w must be 1 for states B and D to E and D transitions.
    assign Y1 = ((y == 3'b001 || y == 3'b011 || y == 3'b100 || y == 3'b101) && w) || 
               ((y == 3'b000 && !w) && !w) ||  // If A and w=0, next state is B
               ((y == 3'b001 && !w) && !w) ||  // If B and w=0, next state is C
               ((y == 3'b010 && !w) && !w) ||  // If C and w=0, next state is E
               ((y == 3'b011 && !w) && !w) ||  // If D and w=0, next state is F
               ((y == 3'b101 && !w) && !w);   // If F and w=0, next state is C

    // Alternatively, focusing solely on y[1] and considering its value in the next state directly:
    // This logic can be further optimized by considering the conditions for y[1] to be 1 in the next state directly.
    // However, the above logic already presents a simplified and direct computation for Y1.

endmodule