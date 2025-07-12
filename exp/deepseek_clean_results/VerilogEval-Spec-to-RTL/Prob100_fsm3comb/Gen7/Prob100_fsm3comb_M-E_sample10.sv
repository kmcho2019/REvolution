module TopModule (
    input in,
    input [1:0] state,
    output [1:0] next_state,
    output out
);

// Next state logic
assign next_state[1] = (~state[1] & state[0] & ~in) | 
                      (state[1] & ~state[0] & in) | 
                      (state[1] & state[0] & ~in);

assign next_state[0] = (~state[1] & ~state[0] & in) | 
                      (~state[1] & state[0]) | 
                      (state[1] & state[0] & in);

// Output logic (Moore: depends only on current state)
assign out = state[1] & state[0];  // Output 1 only in state D (11)

endmodule