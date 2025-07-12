module TopModule (
    input in,
    input [1:0] state,
    output [1:0] next_state,
    output out
);

// Output depends only on current state (Moore machine)
assign out = (state == 2'b11);  // 1 when in state D

// Simplified next state logic
assign next_state[1] = (~state[1] & state[0] & ~in) |  // B and in=0 → C
                       (state[1] & ~state[0] & in) |   // C and in=1 → D
                       (state[1] & state[0] & ~in);    // D and in=0 → C

assign next_state[0] = in & (state[0] | state[1]);     // in=1 and (B, C, or D)

endmodule