module TopModule (
    input in,
    input [3:0] state,
    output [3:0] next_state,
    output out
);

    // Intermediate signal combining current state and input
    wire [3:0] transition_condition = {
        state[2] & in,    // D transition condition
        state[2] & ~in,    // C transition condition
        state[1] | (state[0] & in),  // B transition condition
        (state[0] | state[3]) & ~in  // A transition condition
    };

    // Priority-based next state assignment
    assign next_state[3] = transition_condition[3];  // D
    assign next_state[2] = transition_condition[2] & ~transition_condition[3];  // C
    assign next_state[1] = transition_condition[1] & ~(|transition_condition[3:2]);  // B
    assign next_state[0] = transition_condition[0] & ~(|transition_condition[3:1]);  // A

    // Output is simply state D (MSB of one-hot encoding)
    assign out = state[3];

endmodule