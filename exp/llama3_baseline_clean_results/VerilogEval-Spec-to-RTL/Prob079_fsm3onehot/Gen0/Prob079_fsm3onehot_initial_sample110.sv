module TopModule(
    input  in,
    input [3:0] state,
    output [3:0] next_state,
    output out
);

    // Output logic
    assign out = state[3]; // out is 1 only when state is D

    // Next state logic
    assign next_state[0] = (state[0] && !in) || (state[2] && !in); // A from A or C
    assign next_state[1] = (state[0] && in) || (state[1] && in) || (state[3] && in); // B from A or B or D
    assign next_state[2] = (state[1] && !in); // C from B
    assign next_state[3] = (state[2] && in); // D from C

endmodule