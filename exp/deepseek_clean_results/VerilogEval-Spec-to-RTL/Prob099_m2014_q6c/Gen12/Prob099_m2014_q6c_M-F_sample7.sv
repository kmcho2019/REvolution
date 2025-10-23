module TopModule (
    input [5:0] y,
    input w,
    output Y1,
    output Y2,
    output Y3,
    output Y4
);

    // Next state combinational logic
    wire [5:0] next_state;
    
    assign next_state[0] = (y[0] & w) | (y[3] & w);  // A or D->A
    assign next_state[1] = y[0] & ~w;                 // A->B
    assign next_state[2] = (y[1] & ~w) | (y[5] & ~w); // B->C or F->C
    assign next_state[3] = (y[1] & w) | (y[2] & w) | (y[4] & w) | (y[5] & w); // B/D/E/F->D
    assign next_state[4] = (y[2] & ~w) | (y[4] & ~w); // C->E or E->E
    assign next_state[5] = y[3] & ~w;                 // D->F
    
    assign Y1 = next_state[1];  // Next state B
    assign Y2 = next_state[2];  // Next state C
    assign Y3 = next_state[3];  // Next state D
    assign Y4 = next_state[4];  // Next state E

endmodule