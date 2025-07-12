module TopModule (
    input [2:0] y,
    input w,
    output Y1
);

assign Y1 = y[1];  // Direct output assignment

// Simplified next-state logic for y[1]
wire y1_next = w & ~((~y[2] & ~y[1] & ~y[0]) |  // Not in state A (000)
                    (~y[2] & y[1] & y[0]));    // Not in state D (011)

endmodule