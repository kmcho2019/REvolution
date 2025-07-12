module TopModule (
    input  in,
    input  [3:0] state,
    output [3:0] next_state,
    output out
);

    assign next_state[0] = (~in) & (state[0] | state[2]);   // A next
    assign next_state[1] = in    & (state[0] | state[1] | state[3]); // B next
    assign next_state[2] = (~in) & (state[1] | state[3]);   // C next
    assign next_state[3] = in    & state[2];                // D next

    assign out = state[3];  // Output 1 only in state D

endmodule