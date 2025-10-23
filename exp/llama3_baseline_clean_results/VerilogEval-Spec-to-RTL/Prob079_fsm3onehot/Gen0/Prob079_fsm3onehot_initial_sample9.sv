module TopModule(
    input  in,
    input  [3:0] state,
    output [3:0] next_state,
    output out
);

    assign next_state[0] = (state[0] && !in) || (state[2] && !in);  // next state A
    assign next_state[1] = (state[0] && in) || (state[1] && in) || (state[3] && in);  // next state B
    assign next_state[2] = (state[1] && !in) || (state[3] && !in);  // next state C
    assign next_state[3] = (state[2] && in);  // next state D

    assign out = state[3];  // output is 1 when current state is D

endmodule