module TopModule(
    input in,
    input [3:0] state,
    output [3:0] next_state,
    output out
);

    // next state logic
    assign next_state[0] = (state[0] && !in) || (state[2] && !in);  // A
    assign next_state[1] = (state[0] && in) || (state[1] && (in || !in)) || (state[3] && in);  // B
    assign next_state[2] = (state[1] && !in) || (state[3] && !in);  // C
    assign next_state[3] = (state[2] && in);  // D

    // output logic
    assign out = state[3];  // Output is 1 only if state is D

endmodule