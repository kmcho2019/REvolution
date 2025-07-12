module TopModule(
    input        in,
    input  [9:0] state,
    output [9:0] next_state,
    output       out1,
    output       out2
);

    // Break down next_state[0] into smaller groups to reduce large fan-in
    wire ns0_part1 = state[0] & ~in;
    wire ns0_part2 = state[1] & ~in;
    wire ns0_part3 = state[2] & ~in;
    wire ns0_part4 = state[3] & ~in;
    wire ns0_part5 = state[4] & ~in;
    wire ns0_part6 = state[7] & ~in;
    wire ns0_part7 = state[8] & ~in;
    wire ns0_part8 = state[9] & ~in;

    wire ns0_low  = ns0_part1 | ns0_part2 | ns0_part3 | ns0_part4;
    wire ns0_high = ns0_part5 | ns0_part6 | ns0_part7 | ns0_part8;

    assign next_state[0] = ns0_low | ns0_high;

    // Other next_state bits remain direct assignments as in original solution
    assign next_state[1] = (state[0] & in) | (state[8] & in) | (state[9] & in);
    assign next_state[2] = state[1] & in;
    assign next_state[3] = state[2] & in;
    assign next_state[4] = state[3] & in;
    assign next_state[5] = state[4] & in;
    assign next_state[6] = state[5] & in;
    assign next_state[7] = (state[6] & in) | (state[7] & in);
    assign next_state[8] = state[5] & ~in;
    assign next_state[9] = state[6] & ~in;

    // Output logic remains same and optimal
    assign out1 = state[8] | state[9];
    assign out2 = state[7] | state[9];

endmodule