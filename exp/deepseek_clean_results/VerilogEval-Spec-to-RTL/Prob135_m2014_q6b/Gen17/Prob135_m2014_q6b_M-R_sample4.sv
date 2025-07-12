module TopModule (
    input [2:0] y,
    input w,
    output Y1
);

    assign Y1 = y[1];

    // Next-state logic for y[1]
    wire next_y1;
    assign next_y1 = 
        (~w & (y == 3'b001 | y == 3'b101)) |  // B->C or F->C when w=0
        (w & (y == 3'b001 | y == 3'b010 | y == 3'b011 | y == 3'b101)) |  // Any->D when w=1
        (y == 3'b100 & ~w);  // E maintains y[1]=1 when w=0

endmodule