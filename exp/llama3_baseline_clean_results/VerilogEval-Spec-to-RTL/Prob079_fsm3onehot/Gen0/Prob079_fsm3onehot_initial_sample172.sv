module TopModule(
    input  in,
    input  [3:0] state,
    output [3:0] next_state,
    output out
);

    // Next state logic
    assign next_state[0] = (in == 0 && (state[0] == 1 || state[2] == 1)) || (in == 1 && (state[2] == 1));
    assign next_state[1] = (in == 0 && state[1] == 1) || (in == 1 && (state[0] == 1 || state[1] == 1 || state[3] == 1));
    assign next_state[2] = (in == 0 && (state[1] == 1 || state[3] == 1));
    assign next_state[3] = (in == 1 && state[2] == 1);

    // Output logic
    assign out = state[3];

endmodule