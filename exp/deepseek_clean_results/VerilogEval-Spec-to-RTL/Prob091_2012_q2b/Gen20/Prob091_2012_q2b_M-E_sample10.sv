module TopModule (
    input [5:0] y,
    input w,
    output Y1,
    output Y3
);

    // Next state computation for all bits (though we only need Y1 and Y3)
    wire [5:0] next_state;
    
    // State A transitions
    assign next_state[0] = y[0] & ~w;  // Stay in A if w=0
    
    // State B transitions (Y1)
    assign next_state[1] = (y[0] & w) |  // A->B if w=1
                          (y[5] & w);    // F->C (but C is y[2], not B)
    
    // State C transitions
    assign next_state[2] = (y[1] & w) |  // B->C if w=1
                          (y[5] & w);    // F->C if w=1
    
    // State D transitions (Y3)
    assign next_state[3] = (y[1] & ~w) |  // B->D if w=0
                          (y[2] & ~w) |   // C->D if w=0
                          (y[4] & ~w) |   // E->D if w=0
                          (y[5] & ~w);    // F->D if w=0
    
    // State E transitions
    assign next_state[4] = (y[2] & w) |  // C->E if w=1
                          (y[4] & w);     // E->E if w=1
    
    // State F transitions
    assign next_state[5] = y[3] & w;     // D->F if w=1
    
    // Output only the required bits
    assign Y1 = next_state[1];
    assign Y3 = next_state[3];

endmodule