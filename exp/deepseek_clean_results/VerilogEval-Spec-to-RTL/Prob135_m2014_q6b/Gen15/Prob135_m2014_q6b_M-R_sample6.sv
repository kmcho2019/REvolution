module TopModule (
    input [2:0] y,
    input w,
    output Y1
);

    assign Y1 = y[1];

    wire next_y1;

    // Next state logic for y[1]
    assign next_y1 = 
        // Cases where y[1] becomes 1
        ((y == 3'b001) & ~w) |  // B->C
        ((y == 3'b001) & w)  |  // B->D
        ((y == 3'b010) & w)  |  // C->D
        ((y == 3'b011) & ~w) |  // D->F
        ((y == 3'b101) & ~w) |  // F->C
        ((y == 3'b101) & w)  |  // F->D
        // Cases where y[1] stays 1
        ((y == 3'b011) & w)  |  // D->A (but y[1] was already 1)
        ((y == 3'b100) & ~w) |  // E->E
        ((y == 3'b100) & w)  |  // E->D
        ((y == 3'b101) & ~w) |  // F->C
        ((y == 3'b101) & w);    // F->D

endmodule