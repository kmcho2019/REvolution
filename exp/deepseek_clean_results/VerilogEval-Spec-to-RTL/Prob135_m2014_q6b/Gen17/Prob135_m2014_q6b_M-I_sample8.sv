module TopModule (
    input [2:0] y,
    input w,
    output Y1
);

    assign Y1 = y[1];

    wire next_y1;

    // Next state logic for y[1]
    assign next_y1 = 
        // Cases where next state has y[1] = 1 (states D, E, F)
        ((y == 3'b001) & w)  |  // B->D (next state D:011)
        ((y == 3'b010) & w)  |  // C->D (next state D:011)
        ((y == 3'b011) & ~w) |  // D->F (next state F:101)
        ((y == 3'b100) & ~w) |  // E->E (next state E:100)
        ((y == 3'b100) & w)  |  // E->D (next state D:011)
        ((y == 3'b101) & w)  |  // F->D (next state D:011)
        ((y == 3'b001) & ~w);   // B->C (next state C:010) - y[1] becomes 1

    // Note: All other cases implicitly result in y[1] = 0
    // Including:
    // A->A (next state A:000)
    // A->B (next state B:001)
    // B->C (next state C:010) - y[1] becomes 1 (included above)
    // C->E (next state E:100) - covered by y==3'b010 & ~w
    // D->A (next state A:000)
    // F->C (next state C:010)

endmodule