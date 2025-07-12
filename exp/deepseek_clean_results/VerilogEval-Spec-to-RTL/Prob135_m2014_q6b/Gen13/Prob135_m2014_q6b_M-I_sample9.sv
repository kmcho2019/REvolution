module TopModule (
    input [2:0] y,
    input w,
    output Y1
);

    assign Y1 = y[1];

    // Next-state logic for y[1]
    wire next_y1 = 
        (y == 3'b001 & w) |  // B→D when w=1
        (y == 3'b010 & w) |  // C→D when w=1
        (y == 3'b011 & ~w) | // D→F when w=0
        (y == 3'b100 & w) |  // E→D when w=1
        (y == 3'b101);       // F→C (w=0) or F→D (w=1) - both have y[1]=1

endmodule