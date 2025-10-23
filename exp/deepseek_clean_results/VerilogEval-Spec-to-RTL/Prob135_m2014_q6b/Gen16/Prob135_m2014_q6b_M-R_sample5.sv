module TopModule (
    input [2:0] y,
    input w,
    output Y1
);

    assign Y1 = y[1];

    // Next state logic for y[1]
    // y[1] becomes 1 when transitioning to states D (011), E (100), or F (101)
    wire next_y1 = 
        // From B (001): transitions to D (011) on w=1 or C (010) on w=0
        ((y == 3'b001) & w) |  // B->D
        // From C (010): transitions to D (011) on w=1
        ((y == 3'b010) & w) |  // C->D
        // From D (011): transitions to F (101) on w=0
        ((y == 3'b011) & ~w) | // D->F
        // From E (100): stays in E (100) on w=0 or transitions to D (011) on w=1
        ((y == 3'b100) & ~w) | // E->E
        ((y == 3'b100) & w) |  // E->D
        // From F (101): transitions to C (010) on w=0 or D (011) on w=1
        ((y == 3'b101) & w);   // F->D

endmodule