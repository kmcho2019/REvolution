module TopModule (
    input [5:0] y,
    input w,
    output Y1,
    output Y3
);

    // Next state logic optimized for one-hot encoding
    wire [5:0] next_state;
    
    assign next_state[0] = y[3] & ~w;  // D->A when w=0
    assign next_state[1] = y[0] & w;   // A->B when w=1
    assign next_state[2] = (y[1] | y[5]) & w;  // B->C or F->C when w=1 (can't be simultaneous)
    assign next_state[3] = (y[1] | y[2] | y[4] | y[5]) & ~w;  // To D when w=0 (only one active)
    assign next_state[4] = (y[2] | y[4]) & w;  // C->E or E->E when w=1
    assign next_state[5] = y[3] & w;   // D->F when w=1

    // Output the required next state bits
    assign Y1 = next_state[1];
    assign Y3 = next_state[3];

endmodule