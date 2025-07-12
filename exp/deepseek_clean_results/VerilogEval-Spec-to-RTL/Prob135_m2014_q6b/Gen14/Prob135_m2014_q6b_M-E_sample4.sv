module TopModule (
    input [2:0] y,
    input w,
    output Y1
);

    assign Y1 = y[1];

    // Next-state logic for y[1] using explicit case analysis
    wire next_y1;
    assign next_y1 = 
        ((y == 3'b001) && w) ||  // B→D when w=1
        ((y == 3'b010) && w) ||  // C→D when w=1
        ((y == 3'b011) && ~w) || // D→F when w=0
        ((y == 3'b100) && w) ||  // E→D when w=1
        ((y == 3'b101) && w);    // F→D when w=1
        // All other cases result in y[1]=0 in next state

endmodule