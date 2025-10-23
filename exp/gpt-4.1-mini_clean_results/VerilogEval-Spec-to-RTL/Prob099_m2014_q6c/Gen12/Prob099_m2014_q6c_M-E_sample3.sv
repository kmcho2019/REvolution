module TopModule(
    input  [5:0] y,   // Current state one-hot encoding
    input        w,   // Input signal
    output       Y1,  // Next state bit y[1] (state B)
    output       Y3   // Next state bit y[3] (state D)
);

    wire [5:0] next_state;

    // Define next_state bits for each possible current state and input w

    // State encoding:
    // y[0]: A
    // y[1]: B
    // y[2]: C
    // y[3]: D
    // y[4]: E
    // y[5]: F

    // Initialize all bits to 0
    // Then OR in all transitions from each state per w

    // From A (y[0]):
    // w=0: next B (y[1])
    // w=1: next A (y[0])
    wire next_A_from_A = y[0] & w;
    wire next_B_from_A = y[0] & ~w;

    // From B (y[1]):
    // w=0: next C (y[2])
    // w=1: next D (y[3])
    wire next_C_from_B = y[1] & ~w;
    wire next_D_from_B = y[1] & w;

    // From C (y[2]):
    // w=0: next E (y[4])
    // w=1: next D (y[3])
    wire next_E_from_C = y[2] & ~w;
    wire next_D_from_C = y[2] & w;

    // From D (y[3]):
    // w=0: next F (y[5])
    // w=1: next A (y[0])
    wire next_F_from_D = y[3] & ~w;
    wire next_A_from_D = y[3] & w;

    // From E (y[4]):
    // w=0: next E (y[4])
    // w=1: next D (y[3])
    wire next_E_from_E = y[4] & ~w;
    wire next_D_from_E = y[4] & w;

    // From F (y[5]):
    // w=0: next C (y[2])
    // w=1: next D (y[3])
    wire next_C_from_F = y[5] & ~w;
    wire next_D_from_F = y[5] & w;

    // Combine all contributions for each next state bit
    assign next_state[0] = next_A_from_A | next_A_from_D;           // A
    assign next_state[1] = next_B_from_A;                           // B
    assign next_state[2] = next_C_from_B | next_C_from_F;           // C
    assign next_state[3] = next_D_from_B | next_D_from_C | next_D_from_E | next_D_from_F; // D
    assign next_state[4] = next_E_from_C | next_E_from_E;           // E
    assign next_state[5] = next_F_from_D;                           // F

    // Outputs are the next-state bits corresponding to y[1] and y[3]
    assign Y1 = next_state[1];
    assign Y3 = next_state[3];

endmodule