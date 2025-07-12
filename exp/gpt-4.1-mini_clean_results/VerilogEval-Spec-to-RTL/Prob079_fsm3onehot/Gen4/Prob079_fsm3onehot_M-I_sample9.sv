module TopModule (
    input        in,
    input  [3:0] state,
    output [3:0] next_state,
    output       out
);

    // State bits for convenience
    wire A = state[0];
    wire B = state[1];
    wire C = state[2];
    wire D = state[3];

    // Factor common terms for next_state[1]
    wire in_and_state = in & (A | B | D);

    // Factor common terms for next_state[0]
    wire notin_and_ac = (~in) & (A | C);

    // Factor common terms for next_state[2]
    wire notin_and_bd = (~in) & (B | D);

    // Next state logic with factored terms
    assign next_state[0] = notin_and_ac;    // Next state A
    assign next_state[1] = in_and_state;    // Next state B
    assign next_state[2] = notin_and_bd;    // Next state C
    assign next_state[3] = C & in;          // Next state D

    // Output logic (Moore machine output depends only on current state)
    assign out = D;

endmodule