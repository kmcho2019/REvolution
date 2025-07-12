module TopModule (
    input [2:0] y,
    input w,
    output Y1
);

    assign Y1 = y[1];

    // Next-state logic for y[1] using priority encoding
    wire next_y1;
    assign next_y1 = 
        // Priority 1: Cases where y[1] must be 1
        ((y == 3'b001) |               // From B (goes to C or D)
         ((y == 3'b010) & w) |         // From C when w=1 (goes to D)
         ((y == 3'b100) & ~w) |        // From E when w=0 (stays E)
         ((y == 3'b101) & w)) ? 1'b1 : // From F when w=1 (goes to D)
        // Priority 2: Cases where y[1] must be 0
        (((y == 3'b011) & w) |         // From D when w=1 (goes to A)
         ((y == 3'b101) & ~w)) ? 1'b0 : // From F when w=0 (goes to C)
        // Default: maintain current y[1]
        y[1];

endmodule