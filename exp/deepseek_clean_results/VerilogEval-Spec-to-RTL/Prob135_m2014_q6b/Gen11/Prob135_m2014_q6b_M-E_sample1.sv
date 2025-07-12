module TopModule (
    input [2:0] y,
    input w,
    output Y1
);

assign Y1 = y[1];  // Direct output assignment

// Next-state logic for y[1] derived from truth table and K-map optimization
wire y1_next = (~y[2] & ~y[1] & y[0] & ~w) |  // State B -> C
               (~y[2] & y[1] & ~w) |          // State C -> E
               (y[2] & ~y[0] & w) |           // State E -> D when w=1
               (y[2] & y[0]);                // States D and F transitions

endmodule