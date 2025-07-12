module TopModule (
    input [5:0] y,
    input w,
    output Y1,
    output Y3
);

    // Next state transition matrix
    wire [5:0] next_state;
    
    // A transitions
    assign next_state[0] = y[0] & ~w;  // A->A
    assign next_state[1] = y[0] & w;   // A->B
    
    // B transitions
    assign next_state[2] = y[1] & w;   // B->C
    assign next_state[3] = y[1] & ~w;  // B->D
    
    // C transitions
    assign next_state[4] = y[2] & w;   // C->E
    assign next_state[3] = next_state[3] | (y[2] & ~w);  // C->D
    
    // D transitions
    assign next_state[5] = y[3] & w;   // D->F
    assign next_state[0] = next_state[0] | (y[3] & ~w);  // D->A
    
    // E transitions
    assign next_state[4] = next_state[4] | (y[4] & w);   // E->E
    assign next_state[3] = next_state[3] | (y[4] & ~w);  // E->D
    
    // F transitions
    assign next_state[2] = next_state[2] | (y[5] & w);   // F->C
    assign next_state[3] = next_state[3] | (y[5] & ~w);  // F->D
    
    // Output mapping (Y1 = B, Y3 = D)
    assign Y1 = next_state[1];
    assign Y3 = next_state[3];

endmodule