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

    wire in_n = ~in;

    assign next_state[0] = in_n & (A | C);     // A->A or C->A when in=0
    assign next_state[1] = in   & (A | B | D); // A->B, B->B, D->B when in=1
    assign next_state[2] = in_n & (B | D);     // B->C or D->C when in=0
    assign next_state[3] = in   & C;           // C->D when in=1

    assign out = D;

endmodule