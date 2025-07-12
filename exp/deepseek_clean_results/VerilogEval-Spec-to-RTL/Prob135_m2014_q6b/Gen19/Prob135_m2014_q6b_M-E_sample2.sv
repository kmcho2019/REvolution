module TopModule (
    input [2:0] y,
    input w,
    output Y1
);

    assign Y1 = y[1];

    // Next-state logic for y[1]
    wire next_y1;
    assign next_y1 = 
        // Cases where y[1] becomes 1
        ((y == 3'b001) & ~w) |  // B->C (w=0)
        ((y == 3'b001) & w)  |  // B->D (w=1)
        ((y == 3'b010) & w)  |  // C->D (w=1)
        // Cases where y[1] stays 1
        ((y == 3'b011) & ~w) |  // D->F (w=0) (F has y[1]=1)
        ((y == 3'b100) & ~w) |  // E->E (w=0)
        ((y == 3'b100) & w)  |  // E->D (w=1)
        ((y == 3'b101) & w)  |  // F->D (w=1)
        // Default case: y[1] stays same (covers A->A/B, C->E, F->C)
        (y[1] & ~((y == 3'b011) & w) & ~((y == 3'b101) & ~w));

endmodule