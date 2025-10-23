module TopModule (
    input [2:0] y,
    input w,
    output Y1
);

    assign Y1 = y[1];

    // Next-state logic for y[1]
    wire next_y1;
    assign next_y1 = 
        (~w & y == 3'b001) |        // B->C when w=0
        (w & (y == 3'b001 |         // B->D when w=1
              y == 3'b010 |         // C->D when w=1
              y == 3'b011 |         // D->D when w=1 (but D->A actually)
              y == 3'b100 |         // E->D when w=1
              y == 3'b101)) |       // F->D when w=1
        (~w & y == 3'b100) |        // E->E when w=0
        (~w & y == 3'b011);         // D->F when w=0

endmodule