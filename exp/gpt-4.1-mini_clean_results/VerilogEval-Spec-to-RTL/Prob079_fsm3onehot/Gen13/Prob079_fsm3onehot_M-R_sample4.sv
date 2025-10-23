module TopModule (
    input        in,
    input  [3:0] state,
    output [3:0] next_state,
    output       out
);

    // State bits for clarity
    wire A = state[0];
    wire B = state[1];
    wire C = state[2];
    wire D = state[3];

    // Intermediate signals for next states based on input and current state
    wire nextA_fromA0 = A & ~in;
    wire nextA_fromC0 = C & ~in;

    wire nextB_fromA1 = A & in;
    wire nextB_fromB0 = B & in; // For input=1 B->B transition
    wire nextB_fromD1 = D & in;

    wire nextC_fromB0 = B & ~in;
    wire nextC_fromD0 = D & ~in;

    wire nextD_fromC1 = C & in;

    // Next state bits are OR of all possible transitions to that state
    assign next_state[0] = nextA_fromA0 | nextA_fromC0;            // Next A
    assign next_state[1] = nextB_fromA1 | nextB_fromB0 | nextB_fromD1; // Next B
    assign next_state[2] = nextC_fromB0 | nextC_fromD0;            // Next C
    assign next_state[3] = nextD_fromC1;                           // Next D

    // Output asserted only in state D (Moore output)
    assign out = D;

endmodule