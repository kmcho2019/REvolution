module TopModule (
    input [2:0] y,
    input w,
    output Y1
);

    assign Y1 = y[1];  // Direct output assignment

    // Next state logic for y[1] using exhaustive case analysis
    wire next_y1 = 
        // Cases where next y[1] is 1
        (y == 3'b001) |                    // B -> C/D (both have y[1]=1)
        (y == 3'b010 & w) |                // C -> D
        (y == 3'b011 & ~w) |               // D -> F
        (y == 3'b100) |                    // E -> E/D (both have y[1]=1)
        (y == 3'b101);                     // F -> C/D (C has y[1]=1 when coming from F)

    // Note: All other cases implicitly result in next_y1 = 0
    // including: A (stays A), D->A, F->D when w=1, etc.

endmodule