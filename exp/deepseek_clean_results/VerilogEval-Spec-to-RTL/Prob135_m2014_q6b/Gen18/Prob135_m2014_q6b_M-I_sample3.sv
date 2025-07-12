module TopModule (
    input [2:0] y,
    input w,
    output Y1
);

    assign Y1 = y[1];

    // Correct next-state logic for y[1]
    wire next_y1;
    assign next_y1 = 
        (y == 3'b100) |                      // E maintains y[1]=1
        (y == 3'b011 & ~w) |                 // D->F when w=0
        ((y == 3'b001 | y == 3'b010 | y == 3'b101) & w);  // B/C/F->D when w=1

endmodule