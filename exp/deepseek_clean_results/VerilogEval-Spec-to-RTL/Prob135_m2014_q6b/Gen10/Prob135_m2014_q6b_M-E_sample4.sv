module TopModule (
    input [2:0] y,
    input w,
    output Y1
);

    assign Y1 = y[1];  // Direct output assignment

    // Next-state logic for y[1] using optimized bitwise operations
    wire next_y1;
    assign next_y1 = 
        // Cases where next y[1] is 1:
        // Transition to D (011) from B/C/E/F when w=1
        // Transition to E (100) from C when w=0
        // Stay in E (100) when w=0
        ((y == 3'b001 & w) |  // B->D
         (y == 3'b010 & w) |  // C->D
         (y == 3'b011 & w) |  // D->A (but A's y[1] is 0, so not here)
         (y == 3'b100 & ~w) | // E->E
         (y == 3'b100 & w) |  // E->D
         (y == 3'b101 & w)    // F->D
        ) ? 1'b1 : 1'b0;

endmodule