module TopModule (
    input [2:0] y,
    input w,
    output Y1
);

assign Y1 = y[1];  // Direct output assignment

// Corrected next-state logic for y[1]
wire y1_next = (~y[2] & ~y[1] & y[0] & w) |  // State B -> D when w=1
               (~y[2] & y[1] & ~w) |         // State C -> E when w=0
               (y[2] & ~y[0] & w) |         // State E -> D when w=1
               (y[2] & y[0] & ~w);          // State F -> C when w=0

endmodule