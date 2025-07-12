module TopModule(
    input  [5:0] y,  // Current state
    input        w,  // Input signal
    output       Y1, // Next-state signal for y[1] (state B)
    output       Y2, // Next-state signal for y[2] (state C)
    output       Y3, // Next-state signal for y[3] (state D)
    output       Y4  // Next-state signal for y[4] (state E)
);

// State A (y[0] = 1)
assign Y1 = (y[0] && w);  // Transition from A to B
assign Y2 = 0;           // No direct transition from A to C
assign Y3 = 0;           // No direct transition from A to D
assign Y4 = 0;           // No direct transition from A to E

// State B (y[1] = 1)
assign Y1 = (y[1] && ~w);  // Stay in B if w=0
assign Y2 = (y[1] && ~w);  // Transition from B to C if w=0
assign Y3 = (y[1] && w);   // Transition from B to D if w=1
assign Y4 = 0;             // No direct transition from B to E

// State C (y[2] = 1)
assign Y1 = 0;           // No direct transition from C to B
assign Y2 = (y[2] && ~w);  // Stay in C if w=0
assign Y3 = (y[2] && ~w) || (y[2] && w);  // Transition from C to D
assign Y4 = 0;             // No direct transition from C to E

// State D (y[3] = 1)
assign Y1 = 0;           // No direct transition from D to B
assign Y2 = 0;           // No direct transition from D to C
assign Y3 = (y[3] && ~w) || (y[3] && w);  // Stay in D or transition to other states
assign Y4 = (y[3] && w);  // Transition from D to E if w=1

// State E (y[4] = 1)
assign Y1 = 0;           // No direct transition from E to B
assign Y2 = 0;           // No direct transition from E to C
assign Y3 = (y[4] && ~w) || (y[4] && w);  // Transition from E to D
assign Y4 = (y[4] && w);  // Stay in E if w=1

// State F (y[5] = 1)
assign Y1 = 0;           // No direct transition from F to B
assign Y2 = (y[5] && w);  // Transition from F to C if w=1
assign Y3 = (y[5] && ~w) || (y[5] && w);  // Transition from F to D
assign Y4 = 0;             // No direct transition from F to E

endmodule