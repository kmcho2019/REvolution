module TopModule (
    input        in,
    input  [3:0] state,
    output [3:0] next_state,
    output       out
);

    // One-hot state bits
    wire A = state[0];
    wire B = state[1];
    wire C = state[2];
    wire D = state[3];

    // Direct next state assignments from state transition table
    assign next_state[0] = (~in & A) | (~in & C);   // Next A from A or C when in=0
    assign next_state[1] = (in & A) | (in & B) | (in & D); // Next B from A, B, or D when in=1
    assign next_state[2] = (~in & B) | (~in & D);   // Next C from B or D when in=0
    assign next_state[3] = (in & C);                 // Next D from C when in=1

    // Output is 1 only in state D
    assign out = D;

endmodule