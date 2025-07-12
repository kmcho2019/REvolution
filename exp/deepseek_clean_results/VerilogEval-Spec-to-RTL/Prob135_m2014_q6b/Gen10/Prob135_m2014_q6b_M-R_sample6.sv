module TopModule (
    input [2:0] y,
    input w,
    output Y1
);

    assign Y1 = y[1];

    // Next-state logic for y[1] with corrected transitions
    wire next_y1;
    assign next_y1 = 
        // States where next y[1] is always 1 (B->C/D, F->C/D)
        ((y == 3'b001) | (y == 3'b101)) ? 1'b1 :
        // States where next y[1] depends on w (C, E)
        ((y == 3'b010) | (y == 3'b100)) ? w :
        // Default case (A, D) where next y[1] is 0
        1'b0;

endmodule