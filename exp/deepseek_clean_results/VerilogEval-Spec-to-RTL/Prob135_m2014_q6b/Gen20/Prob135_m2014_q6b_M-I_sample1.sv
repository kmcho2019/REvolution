module TopModule (
    input [2:0] y,
    input w,
    output Y1
);

    assign Y1 = y[1];

    // Correct and optimized next-state logic for y[1]
    wire next_y1;
    assign next_y1 = 
        (y == 3'b001 & w) |  // B with w=1 → D
        (y == 3'b010 & w) |  // C with w=1 → D
        (y == 3'b011 & ~w) | // D with w=0 → F
        (y == 3'b100) |      // E always → E or D (both have y[1]=1)
        (y == 3'b101 & w);   // F with w=1 → D

endmodule