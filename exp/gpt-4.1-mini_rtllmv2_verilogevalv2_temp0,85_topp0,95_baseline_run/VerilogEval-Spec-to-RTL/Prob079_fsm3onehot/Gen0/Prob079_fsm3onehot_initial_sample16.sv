module TopModule(
    input  in,
    input  [3:0] state,
    output [3:0] next_state,
    output out
);
    // Current states
    wire A = state[0];
    wire B = state[1];
    wire C = state[2];
    wire D = state[3];
    
    // Next state bits
    // From the table:
    // State A: in=0->A, in=1->B
    // next_state[0] = A & ~in
    // next_state[1] = A & in
    // next_state[2] = ...
    // State B: in=0->C, in=1->B
    // next_state[2] = B & ~in
    // next_state[1] = B & in (also from A in=1)
    // State C: in=0->A, in=1->D
    // next_state[0] = ... + C & ~in
    // next_state[3] = C & in
    // State D: in=0->C, in=1->B
    // next_state[2] = ... + D & ~in
    // next_state[1] = ... + D & in

    assign next_state[0] = (A & ~in) | (C & ~in);
    assign next_state[1] = (A & in) | (B & in) | (D & in);
    assign next_state[2] = (B & ~in) | (D & ~in);
    assign next_state[3] = (C & in);

    // Output is 1 only in state D, otherwise 0
    assign out = D;

endmodule