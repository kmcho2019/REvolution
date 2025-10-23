module TopModule (
    input        in,
    input  [3:0] state,
    output [3:0] next_state,
    output       out
);

    // One-hot encoded states for clarity
    wire A = state[0];
    wire B = state[1];
    wire C = state[2];
    wire D = state[3];

    wire in_n = ~in;

    // Factor groups of states per next_state bit
    wire group0 = A | C;       // States that go to A when in=0
    wire group1 = A | B | D;   // States that go to B when in=1
    wire group2 = B | D;       // States that go to C when in=0
    // next_state[3] is simply in & C per table

    // Assign next state logic with factoring
    assign next_state[0] = in_n & group0;
    assign next_state[1] = in   & group1;
    assign next_state[2] = in_n & group2;
    assign next_state[3] = in   & C;

    // Output is high only in state D (Moore output)
    assign out = D;

endmodule