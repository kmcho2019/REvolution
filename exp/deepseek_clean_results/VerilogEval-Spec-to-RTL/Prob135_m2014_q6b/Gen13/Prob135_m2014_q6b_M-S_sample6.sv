module TopModule (
    input [2:0] y,
    input w,
    output Y1
);

    assign Y1 = y[1];

    // Simplified next-state logic for y[1]
    wire next_y1;
    assign next_y1 = 
        ((y == 3'b000 & ~w) |  // A->B
         (y == 3'b010 & ~w) |  // C->E
         (y == 3'b011 & ~w))   // D->F
        ? 1'b0 : 1'b1;

endmodule