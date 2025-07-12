module TopModule (
    input in,
    input [3:0] state,
    output [3:0] next_state,
    output out
);

    // Priority-based state transition logic
    wire state_D = state[3];
    wire state_C = state[2] & ~state_D;
    wire state_B = state[1] & ~state_C & ~state_D;
    wire state_A = state[0] & ~state_B & ~state_C & ~state_D;

    assign next_state[0] = (state_A & ~in) | (state_C & ~in);
    assign next_state[1] = (state_A & in) | (state_B & in) | (state_D & in);
    assign next_state[2] = (state_B & ~in) | (state_D & ~in);
    assign next_state[3] = (state_C & in);

    // Output logic - OR of all output conditions (only state D in this case)
    assign out = state_D;

endmodule