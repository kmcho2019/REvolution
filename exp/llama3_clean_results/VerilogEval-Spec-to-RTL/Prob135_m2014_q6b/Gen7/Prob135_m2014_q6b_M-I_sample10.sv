module TopModule(
    input [2:0] y,
    input w,
    output Y1
);

    assign Y1 = ((y == 3'b001) & ~w) | 
                ((y == 3'b010) & (w | ~w)) | 
                ((y == 3'b011) & ~w) | 
                ((y == 3'b100) & (w | ~w)) | 
                ((y == 3'b101) & (w | ~w));

    // Optimization using K-maps or truth table can be applied here
    // For example:
    // assign Y1 = (y[1] | y[2]) & (w | ~w) | (y == 3'b010);

    // But this doesn't fully represent the FSM, so let's break it down further:
    // We can simplify the conditions as follows:
    assign Y1 = (y[0] & y[2]) |  // For states E and F
                (y[1] & w) |     // For state C to D
                (~y[0] & y[1] & ~w) |  // For state B to C
                (y[0] & ~y[1] & ~y[2] & w);  // For state D to A (not needed, actually, because y[1] will be 0)

endmodule