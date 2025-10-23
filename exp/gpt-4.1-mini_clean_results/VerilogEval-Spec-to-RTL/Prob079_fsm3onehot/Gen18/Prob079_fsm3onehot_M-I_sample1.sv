module TopModule (
    input  in,
    input  [3:0] state,
    output [3:0] next_state,
    output out
);

    wire sa0_ni = state[0] & ~in;
    wire sa2_ni = state[2] & ~in;
    wire sa0_i  = state[0] &  in;
    wire sa1_i  = state[1] &  in;
    wire sa3_i  = state[3] &  in;
    wire sa1_ni = state[1] & ~in;
    wire sa3_ni = state[3] & ~in;

    assign next_state[0] = sa0_ni | sa2_ni;                 // A <= (A, C) when in=0
    assign next_state[1] = sa0_i  | sa1_i | sa3_i;          // B <= (B, D) when in=1 and from A->B at in=1
    assign next_state[2] = sa1_ni | sa3_ni;                 // C <= (B, D) when in=0
    assign next_state[3] = state[2] & in;                   // D <= C when in=1

    assign out = state[3]; // output only depends on state D

endmodule