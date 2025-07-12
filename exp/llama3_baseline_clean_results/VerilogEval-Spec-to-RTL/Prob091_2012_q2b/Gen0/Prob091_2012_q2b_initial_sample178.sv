module TopModule(
    input [5:0] y,  // Current state
    input w,        // Input signal
    output Y1,      // Output for state flip-flop y[1]
    output Y3       // Output for state flip-flop y[3]
);

// For Y1 (y[1]), set when transitioning to state B
assign Y1 = (y[0] &&!w);  // A to B when w is 0

// For Y3 (y[3]), set when transitioning to state D
assign Y3 = (!w && (y[1] || y[2] || y[3] || y[4]));  // B, C, D, E to D when w is 0

endmodule