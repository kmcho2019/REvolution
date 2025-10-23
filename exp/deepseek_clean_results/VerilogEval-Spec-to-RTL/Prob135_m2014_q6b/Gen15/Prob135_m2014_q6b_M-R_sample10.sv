module TopModule (
    input [2:0] y,
    input w,
    output Y1
);

    // Output is current y[1]
    assign Y1 = y[1];

    // Complete next-state logic for y[1]
    wire next_y1;
    assign next_y1 = 
        (y == 3'b001 && w) ||  // B→D when w=1
        (y == 3'b010 && w) ||  // C→D when w=1
        (y == 3'b011 && !w) || // D→F when w=0
        (y == 3'b100 && w) ||  // E→D when w=1
        (y == 3'b101 && w);    // F→D when w=1

endmodule