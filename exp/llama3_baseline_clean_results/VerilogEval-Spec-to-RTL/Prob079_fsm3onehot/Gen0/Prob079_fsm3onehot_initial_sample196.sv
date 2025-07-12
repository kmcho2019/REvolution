module TopModule (
    input in,
    input [3:0] state,
    output [3:0] next_state,
    output out
);

    // Derive next state logic equations by inspection
    // Next state A is the current state A when in is 0, or current state C when in is 0
    assign next_state[0] = (state[0] & ~in) | (state[2] & ~in);
    
    // Next state B is the current state B when in is 1, or current state A when in is 1, or current state D when in is 1
    assign next_state[1] = (state[1] & in) | (state[0] & in) | (state[3] & in);
    
    // Next state C is the current state B when in is 0, or current state D when in is 0
    assign next_state[2] = (state[1] & ~in) | (state[3] & ~in);
    
    // Next state D is the current state C when in is 1
    assign next_state[3] = (state[2] & in);
    
    // Derive output logic equation by inspection
    // Output is 1 when the current state is D
    assign out = state[3];

endmodule