module TopModule(
    input [5:0] y,  // One-hot encoded current state
    input w,
    output Y1,      // Next state bit 0 (A)
    output Y3       // Next state bit 3 (D)
);

    // Next state computation
    wire [5:0] next_state;
    
    assign next_state[0] = (y[0] & w) | (y[3] & w);  // A stays on 1, D->A on 1
    assign next_state[1] = y[0] & ~w;                // A->B on 0
    assign next_state[2] = (y[1] & ~w) | (y[5] & ~w); // B->C or F->C on 0
    assign next_state[3] = (y[1] & w) | (y[2] & w) |  // B/C/E/F->D on 1
                          (y[4] & w) | (y[5] & w);
    assign next_state[4] = (y[2] & ~w) | (y[4] & ~w); // C->E or E stays on 0
    assign next_state[5] = y[3] & ~w;                // D->F on 0

    // Output the required next state bits
    assign Y1 = next_state[0];
    assign Y3 = next_state[3];

endmodule