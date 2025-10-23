module TopModule (
    input  in,
    input  [3:0] state,
    output [3:0] next_state,
    output out
);
    wire in_n = ~in;

    // next_state logic with factored input complements and minimal OR terms
    assign next_state[0] = in_n & (state[0] | state[2]);      // A or C when in=0
    assign next_state[1] = in   & (state[0] | state[1] | state[3]); // B when in=1 from A,B,D
    assign next_state[2] = in_n & (state[1] | state[3]);      // C when in=0 from B,D
    assign next_state[3] = in   & state[2];                   // D when in=1 from C

    // output asserted only in state D
    assign out = state[3];
endmodule