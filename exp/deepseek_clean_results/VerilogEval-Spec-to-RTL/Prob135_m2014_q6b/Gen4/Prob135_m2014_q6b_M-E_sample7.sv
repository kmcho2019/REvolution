module TopModule (
    input [2:0] y,
    input w,
    output Y1
);

assign Y1 = y[1];  // Direct output assignment

// Next-state logic for y[1] using Boolean expressions
wire y1_next = 
    // Transitions to states where y[1] = 1
    (~y[2] & ~y[1] & ~y[0] & ~w) |  // A->B (000, w=0)
    (~y[2] & ~y[1] & y[0] & w) |    // B->D (001, w=1)
    (~y[2] & y[1] & ~y[0] & w) |    // C->D (010, w=1)
    (~y[2] & y[1] & y[0] & ~w) |    // D->F (011, w=0)
    (y[2] & ~y[1] & ~y[0] & w) |    // E->D (100, w=1)
    (y[2] & ~y[1] & y[0] & w);      // F->D (101, w=1)

endmodule