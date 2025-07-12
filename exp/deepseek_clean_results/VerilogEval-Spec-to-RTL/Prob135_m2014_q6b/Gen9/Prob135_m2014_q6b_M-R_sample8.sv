module TopModule (
    input [2:0] y,
    input w,
    output Y1
);

assign Y1 = y[1];  // Direct output assignment

wire y1_next;

assign y1_next = ((y == 3'b001 & ~w) |  // B->C (w=0)
                 ((y == 3'b001 & w) |   // B->D (w=1)
                 ((y == 3'b010 & w) |   // C->D (w=1)
                 ((y == 3'b011 & ~w) |  // D->F (w=0)
                 ((y == 3'b100 & w) |   // E->D (w=1)
                 ((y == 3'b100 & ~w) |  // E->E (w=0) - maintain y[1]
                 ((y == 3'b101 & ~w) |  // F->C (w=0)
                 ((y == 3'b101 & w);    // F->D (w=1)

endmodule