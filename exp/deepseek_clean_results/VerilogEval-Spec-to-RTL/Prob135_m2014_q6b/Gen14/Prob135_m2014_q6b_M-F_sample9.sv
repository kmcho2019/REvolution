module TopModule (
    input [2:0] y,
    input w,
    output Y1
);

    assign Y1 = y[1];

    // Next-state logic for y[1] - only 1 when transitioning to D (011)
    wire next_y1;
    assign next_y1 = 
        (y == 3'b001 & w) |  // B->D when w=1
        (y == 3'b010 & w) |  // C->D when w=1
        (y == 3'b100 & w) |  // E->D when w=1
        (y == 3'b101 & w);   // F->D when w=1

    // Alternative implementation using bit patterns
    // assign next_y1 = w & (
    //     (~y[2] & ~y[1] & y[0]) |  // B (001)
    //     (~y[2] & y[1] & ~y[0]) |  // C (010)
    //     (y[2] & ~y[1] & ~y[0]) |  // E (100)
    //     (y[2] & ~y[1] & y[0])     // F (101)
    // );

endmodule