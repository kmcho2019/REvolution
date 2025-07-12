module TopModule (
    input        in,
    input  [3:0] state,
    output [3:0] next_state,
    output       out
);

    wire A = state[0];
    wire B = state[1];
    wire C = state[2];
    wire D = state[3];

    // Factor common terms in next_state logic
    wire states_for_next_state0 = A | C;         // states that transition to A when in=0
    wire states_for_next_state1 = A | B | D;     // states that transition to B when in=1
    wire states_for_next_state2 = B | D;         // states that transition to C when in=0
    wire states_for_next_state3 = C;              // state that transitions to D when in=1

    assign next_state[0] = states_for_next_state0 & ~in;
    assign next_state[1] = states_for_next_state1 & in;
    assign next_state[2] = states_for_next_state2 & ~in;
    assign next_state[3] = states_for_next_state3 & in;

    assign out = D;

endmodule