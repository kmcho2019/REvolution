module TopModule (
    input        in,
    input  [3:0] state,
    output [3:0] next_state,
    output       out
);

    // One-hot encoded current state bits for clarity
    wire A = state[0];
    wire B = state[1];
    wire C = state[2];
    wire D = state[3];

    wire in_n = ~in; // Inverted input for factoring

    // Next state logic assignments (factored for minimal gates and clarity):
    // next_state A active when in=0 and current state is A or C
    assign next_state[0] = in_n & (A | C);

    // next_state B active when in=1 and current state is A, B, or D
    assign next_state[1] = in & (A | B | D);

    // next_state C active when in=0 and current state is B or D
    assign next_state[2] = in_n & (B | D);

    // next_state D active when in=1 and current state is C
    assign next_state[3] = in & C;

    // Moore machine output: output=1 only in state D
    assign out = D;

endmodule