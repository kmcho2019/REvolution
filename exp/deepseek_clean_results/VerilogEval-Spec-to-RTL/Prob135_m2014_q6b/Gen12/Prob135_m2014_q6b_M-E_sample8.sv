module TopModule (
    input [2:0] y,
    input w,
    output Y1
);

    assign Y1 = y[1];
    
    // Optimized next-state logic for y[1]
    wire next_y1;
    assign next_y1 = (~y[2] & y[1] & w) |    // State B with w=1 (B→D)
                     (~y[2] & y[0]) |        // State C (C→E/D)
                     (y[2] & ~y[0]) |        // State E (E→E/D)
                     (y[2] & y[0] & w);     // State F with w=1 (F→D)

endmodule