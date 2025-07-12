module TopModule(
    input in,
    input [3:0] state,
    output [3:0] next_state,
    output out
);

// Logic for next_state
assign next_state[0] = (~state[3] & ~state[2] & ~state[1] & state[0] & ~in) | 
                       (~state[3] & state[2] & ~state[1] & ~state[0] & ~in) | 
                       (state[3] & ~state[2] & ~state[1] & ~state[0] & ~in);
assign next_state[1] = (~state[3] & ~state[2] & ~state[1] & state[0] & in) | 
                       (~state[3] & ~state[2] & state[1] & ~state[0]) | 
                       (state[3] & ~state[2] & ~state[1] & ~state[0] & in);
assign next_state[2] = (~state[3] & ~state[2] & state[1] & ~state[0] & ~in) | 
                       (~state[3] & state[2] & ~state[1] & ~state[0] & in) | 
                       (state[3] & ~state[2] & ~state[1] & ~state[0] & ~in);
assign next_state[3] = (~state[3] & state[2] & ~state[1] & ~state[0] & in) | 
                       (state[3] & ~state[2] & ~state[1] & ~state[0] & in);

// Logic for out
assign out = state[3];

endmodule