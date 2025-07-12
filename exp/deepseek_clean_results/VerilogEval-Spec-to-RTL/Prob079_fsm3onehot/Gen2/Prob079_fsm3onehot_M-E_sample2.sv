module TopModule (
    input in,
    input [3:0] state,
    output [3:0] next_state,
    output out
);

    // Next state logic using direct bitwise equations
    assign next_state[0] = (state[0] & ~in) | (state[2] & ~in);  // A next
    assign next_state[1] = (state[0] & in) | (state[1] & in) | (state[3] & in);  // B next
    assign next_state[2] = (state[1] & ~in) | (state[3] & ~in);  // C next
    assign next_state[3] = (state[2] & in);                      // D next

    // Output logic remains the same
    assign out = state[3];

endmodule