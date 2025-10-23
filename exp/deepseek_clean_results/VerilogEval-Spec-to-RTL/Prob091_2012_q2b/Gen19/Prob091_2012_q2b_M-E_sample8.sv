module TopModule (
    input [5:0] y,
    input w,
    output Y1,
    output Y3
);

    // Next state computation (parallel evaluation)
    wire [5:0] next_state;
    assign next_state[0] = (y[0] & ~w) | (y[3] & ~w);  // A or D->A
    assign next_state[1] = y[0] & w;                   // A->B
    assign next_state[2] = (y[1] & w) | (y[5] & w);    // B->C or F->C
    assign next_state[3] = (y[1] & ~w) | (y[2] & ~w) | (y[4] & ~w) | (y[5] & ~w); // B/C/E/F->D
    assign next_state[4] = (y[2] & w) | (y[4] & w);    // C->E or E->E
    assign next_state[5] = y[3] & w;                   // D->F

    // Outputs are just the relevant bits from next state
    assign Y1 = next_state[1];
    assign Y3 = next_state[3];

endmodule