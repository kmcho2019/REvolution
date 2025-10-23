module TopModule (
    input        in,
    input  [9:0] state,
    output [9:0] next_state,
    output       out1,
    output       out2
);

    // Masks of current states that transition to next states with input = 0
    wire [9:0] zero_input_state_to_S0 = (state & (
          (1 << 0)  // S0 --0--> S0
        | (1 << 1)  // S1 --0--> S0
        | (1 << 2)  // S2 --0--> S0
        | (1 << 3)  // S3 --0--> S0
        | (1 << 4)  // S4 --0--> S0
        | (1 << 7)  // S7 --0--> S0
        | (1 << 8)  // S8 --0--> S0
        | (1 << 9)  // S9 --0--> S0
    ));

    // Masks for input=1 transitions to each next state
    wire [9:0] one_input_state_to_S1 = (state & ((1 << 0) | (1 << 8) | (1 << 9)));
    wire one_input_state_to_S2 = state[1];
    wire one_input_state_to_S3 = state[2];
    wire one_input_state_to_S4 = state[3];
    wire one_input_state_to_S5 = state[4];
    wire one_input_state_to_S6 = state[5];
    wire one_input_state_to_S7 = (state[6] || state[7]);

    // Masks for input=0 transitions to S8 and S9
    wire zero_input_state_to_S8 = state[5];
    wire zero_input_state_to_S9 = state[6];

    // Compute next_state bits efficiently using input signal
    assign next_state[0] = (~in) && (|zero_input_state_to_S0);
    assign next_state[1] = in && (|one_input_state_to_S1);
    assign next_state[2] = in && one_input_state_to_S2;
    assign next_state[3] = in && one_input_state_to_S3;
    assign next_state[4] = in && one_input_state_to_S4;
    assign next_state[5] = in && one_input_state_to_S5;
    assign next_state[6] = in && one_input_state_to_S6;
    assign next_state[7] = in && one_input_state_to_S7;
    assign next_state[8] = (~in) && zero_input_state_to_S8;
    assign next_state[9] = (~in) && zero_input_state_to_S9;

    // Outputs from current states:
    // out1 = 1 if in S8 or S9 (state[8] or state[9])
    // out2 = 1 if in S7 or S9 (state[7] or state[9])
    assign out1 = state[8] | state[9];
    assign out2 = state[7] | state[9];

endmodule