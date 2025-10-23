module TopModule (
    input [2:0] y,
    input w,
    output Y1
);

// Next-state logic for y[1] using Boolean expressions
wire y1_next = (~y[2] & ~y[1] & w) |  // A -> A (w=1)
                (~y[2] & y[0]) |       // B -> C/D (always 1)
                (y[2] & ~y[1] & ~y[0] & w) |  // E -> E (w=0) or D (w=1)
                (y[2] & y[1] & w) |    // F -> D (w=1)
                (y[1] & ~w);           // C/D -> E/F (when w=0)

assign Y1 = y[1];

endmodule