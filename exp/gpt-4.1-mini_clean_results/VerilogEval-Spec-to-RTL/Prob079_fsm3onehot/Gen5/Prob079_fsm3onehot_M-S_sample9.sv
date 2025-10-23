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

    assign next_state[0] = (A | C) & ~in;  // A for in=0, C for in=0 -> next_state A
    assign next_state[1] = (A | B | D) & in; // A,B,D for in=1 -> next_state B
    assign next_state[2] = (B | D) & ~in;   // B,D for in=0 -> next_state C
    assign next_state[3] = C & in;          // C for in=1 -> next_state D

    assign out = D;

endmodule