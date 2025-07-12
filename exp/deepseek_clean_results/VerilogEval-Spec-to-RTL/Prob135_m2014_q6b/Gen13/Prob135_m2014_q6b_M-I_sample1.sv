module TopModule (
    input [2:0] y,
    input w,
    output Y1
);

    assign Y1 = y[1];

    // Next-state logic for y[1]
    // y[1] is 1 in next state for transitions to D (011) or F (101)
    // But F itself has y[1]=0, only transitions to D set y[1]=1
    wire next_y1;
    assign next_y1 = 
        // Transitions to D (011) where y[1]=1
        ((y == 3'b001) & w) |  // B->D when w=1
        ((y == 3'b010) & w) |  // C->D when w=1
        ((y == 3'b100) & w) |  // E->D when w=1
        ((y == 3'b101) & w) |   // F->D when w=1
        // Transition to F (101) where y[1]=0 (but we don't set y[1] here)
        ((y == 3'b011) & ~w);   // D->F when w=0 (but F has y[1]=0)

    // Corrected implementation focusing only on cases where y[1]=1 in next state
    // Which is only transitions to D (011)
    assign next_y1_correct = 
        (~y[2] & ~y[1] & y[0] & w) |  // B->D
        (~y[2] & y[1] & ~y[0] & w) |  // C->D
        (y[2] & ~y[1] & ~y[0] & w) | // E->D
        (y[2] & ~y[1] & y[0] & w);    // F->D

    // Final optimized version
    assign next_y1_final = 
        w & (
            (~y[2] & ((~y[1] & y[0]) | (y[1] & ~y[0]))) |  // B->D or C->D
            (y[2] & ~y[1])                                  // E->D or F->D
        );

endmodule