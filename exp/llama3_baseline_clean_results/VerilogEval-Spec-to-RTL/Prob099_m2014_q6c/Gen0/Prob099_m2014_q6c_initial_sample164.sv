module TopModule(
    input [5:0] y,
    input w,
    output Y1,
    output Y3
);

// One-hot encoding for states A to F
// A: 000001, B: 000010, C: 000100, D: 001000, E: 010000, F: 100000

// Next-state logic for Y2 (y[1]) - State B
assign Y2 = (y[0] && !w); // From state A to B when w is 0

// Next-state logic for Y4 (y[3]) - State D
assign Y4 = (y[1] && w) || (y[2] && w) || (y[4] && !w) || (y[5] && w); 
// From state B to D when w is 1, from state C to D when w is 1, 
// from state E to D when w is 0, and from state F to D when w is 1

// Output assignments
assign Y1 = y[0]; // Output for state A
assign Y3 = y[2]; // Output for state C

endmodule