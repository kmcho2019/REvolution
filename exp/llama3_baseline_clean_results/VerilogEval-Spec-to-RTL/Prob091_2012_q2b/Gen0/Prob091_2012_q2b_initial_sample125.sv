module TopModule(
    input [5:0] y, // Current state
    input w,      // Input signal
    output Y1,    // Output for state flip-flop y[1]
    output Y3     // Output for state flip-flop y[3]
);

// For Y1 (associated with state B), it should be 1 when the machine is in state A and w=1
assign Y1 = (y[0] && w); // A (000001) to B transition

// For Y3 (associated with state D), it should be 1 in the following conditions:
// - When in state B (000010) and w=0
// - When in state C (000100) and w=0
// - When in state E (010000) and w=0
// - When in state F (100000) and w=0 (since F to C doesn't affect Y3 directly)
assign Y3 = (y[1] && !w) || (y[2] && !w) || (y[4] && !w) || (y[5] && !w);

endmodule