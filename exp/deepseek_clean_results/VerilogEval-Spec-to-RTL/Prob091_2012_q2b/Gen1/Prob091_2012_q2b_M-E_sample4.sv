module TopModule (
    input [5:0] y,
    input w,
    output Y1,
    output Y3
);

    wire [5:0] next_state;

    // Next state logic
    assign next_state[0] = y[3] & ~w;  // From D to A when w=0
    assign next_state[1] = y[0] & w;   // From A to B when w=1
    assign next_state[2] = (y[1] & w) | (y[5] & w);  // From B to C or F to C when w=1
    assign next_state[3] = (y[1] & ~w) | (y[2] & ~w) | (y[4] & ~w) | (y[5] & ~w);  // To D from multiple states when w=0
    assign next_state[4] = (y[2] & w) | (y[4] & w);  // From C to E or E to E when w=1
    assign next_state[5] = y[3] & w;   // From D to F when w=1

    // Output the required next state bits
    assign Y1 = next_state[1];
    assign Y3 = next_state[3];

endmodule