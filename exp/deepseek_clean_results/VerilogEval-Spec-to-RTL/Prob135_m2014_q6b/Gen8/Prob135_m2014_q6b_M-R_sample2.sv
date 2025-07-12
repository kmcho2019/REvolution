module TopModule (
    input [2:0] y,
    input w,
    output Y1
);

assign Y1 = y[1];  // Direct output assignment

wire y1_next;

assign y1_next = ((y == 3'b001) |                 // B->C or B->D
                 ((y == 3'b010) & w) |            // C->D
                 ((y == 3'b011) & ~w) |           // D->F
                 ((y == 3'b100) & w) |            // E->D
                 (y == 3'b101));                 // F->C or F->D

endmodule