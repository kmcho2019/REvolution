module TopModule (
    input  in,
    input  [3:0] state,
    output [3:0] next_state,
    output out
);
    // State bits for readability
    wire A = state[0];
    wire B = state[1];
    wire C = state[2];
    wire D = state[3];
    wire in_n = ~in;

    // Next state logic derived by inspection and factoring common terms
    assign next_state[0] = in_n & (A | C);         // next A
    assign next_state[1] = in  & (A | B | D);      // next B
    assign next_state[2] = in_n & (B | D);         // next C
    assign next_state[3] = in  & C;                 // next D

    // Output logic (Moore): output asserted only in state D
    assign out = D;

endmodule