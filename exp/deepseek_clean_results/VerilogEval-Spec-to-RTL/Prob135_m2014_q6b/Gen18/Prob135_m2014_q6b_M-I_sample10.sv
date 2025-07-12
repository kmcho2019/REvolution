module TopModule (
    input [2:0] y,
    input w,
    output Y1
);

    assign Y1 = y[1];

    wire next_y1;

    // Next state logic for y[1] - set to 1 when next state is C(010), D(011), E(100), or F(101)
    assign next_y1 = 
        (~y[2] & ~y[1] & y[0] & w) |  // B->D (next state D:011)
        (~y[2] & y[1] & ~y[0] & w) |  // C->D (next state D:011)
        (~y[2] & y[1] & y[0] & ~w) |  // D->F (next state F:101)
        (y[2] & ~y[1] & ~y[0] & ~w) | // E->E (next state E:100)
        (y[2] & ~y[1] & ~y[0] & w) |  // E->D (next state D:011)
        (y[2] & ~y[1] & y[0] & w) |   // F->D (next state D:011)
        (~y[2] & ~y[1] & y[0] & ~w) | // B->C (next state C:010)
        (~y[2] & y[1] & ~y[0] & ~w) | // C->E (next state E:100)
        (y[2] & ~y[1] & y[0] & ~w);    // F->C (next state C:010)

    // Alternative more optimized implementation:
    // assign next_y1 = 
    //     (y[0] & w) |                   // B->D or D->F or F->D
    //     (y[1] & w) |                   // C->D
    //     (y[2] & ~w) |                  // E->E or F->C
    //     (~y[2] & ~y[1] & y[0] & ~w) |  // B->C
    //     (~y[2] & y[1] & ~y[0] & ~w);   // C->E

endmodule