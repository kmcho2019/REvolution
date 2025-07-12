module TopModule (
    input        in,
    input  [3:0] state,
    output [3:0] next_state,
    output       out
);

    // Decode current one-hot states
    wire A = state[0];
    wire B = state[1];
    wire C = state[2];
    wire D = state[3];

    // Factor common terms in next_state logic for better synthesis
    wire in_n = ~in;

    assign next_state[0] = (A | C) & in_n;           // A or C go to A when in=0
    assign next_state[1] = (A | B | D) & in;          // A, B, D go to B when in=1
    assign next_state[2] = (B | D) & in_n;           // B or D go to C when in=0
    assign next_state[3] = C & in;                    // C goes to D when in=1

    // Output is 1 only when state D is active
    assign out = D;

endmodule