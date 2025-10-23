module TopModule (
    input [2:0] y,
    input w,
    output Y1
);

    assign Y1 = y[1];
    
    // Correct next-state logic for y[1]
    wire next_y1 = ((y == 3'b001 & w) |  // B->D when w=1
                   (y == 3'b010 & w) |  // C->D when w=1
                   (y == 3'b100 & w) |  // E->D when w=1
                   (y == 3'b101 & w);  // F->D when w=1

endmodule