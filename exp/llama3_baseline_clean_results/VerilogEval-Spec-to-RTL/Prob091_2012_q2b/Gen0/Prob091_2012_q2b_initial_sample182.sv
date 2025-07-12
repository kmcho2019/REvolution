module TopModule(
    input [5:0] y,  // Current state
    input w,       // Input to control state transitions
    output Y1,     // Input of state flip-flop y[1]
    output Y3      // Input of state flip-flop y[3]
);

// Logic for Y1
assign Y1 = (y[0] && !w);  // Transition from A to B

// Logic for Y3
assign Y3 = (!w && (y[1] || y[2] || y[3] || y[4]));  // Transitions to D from B, C, D, E

endmodule