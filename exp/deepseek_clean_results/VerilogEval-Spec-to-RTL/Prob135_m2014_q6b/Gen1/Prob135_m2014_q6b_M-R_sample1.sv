module TopModule (
    input [2:0] y,
    input w,
    output Y1
);

    // Next-state logic for y[1]
    assign next_y1 = (y == 3'b000 & w) |        // A->A (keep 0)
                     (y == 3'b001 & w) |        // B->D (set 1)
                     (y == 3'b010 & w) |        // C->D (set 1)
                     (y == 3'b011 & ~w) |       // D->F (set 1)
                     (y == 3'b100 & w) |        // E->D (set 1)
                     (y == 3'b101 & w);         // F->D (set 1)

    // Output assignment
    assign Y1 = y[1];

endmodule