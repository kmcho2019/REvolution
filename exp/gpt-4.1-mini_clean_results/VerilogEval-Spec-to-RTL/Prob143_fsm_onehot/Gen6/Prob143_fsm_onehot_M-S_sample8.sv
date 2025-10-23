module TopModule(
    input        in,
    input  [9:0] state,
    output [9:0] next_state,
    output       out1,
    output       out2
);

    wire zero_in = ~in;
    wire one_in  =  in;

    // next_state[0] transitions to S0 from states on input 0
    assign next_state[0] = (state[0] | state[1] | state[2] | state[3] | state[4] | state[7] | state[8] | state[9]) & zero_in;

    // next_state assignments per FSM transitions
    assign next_state[1] = (state[0] | state[8] | state[9]) & one_in;
    assign next_state[2] = state[1] & one_in;
    assign next_state[3] = state[2] & one_in;
    assign next_state[4] = state[3] & one_in;
    assign next_state[5] = state[4] & one_in;
    assign next_state[6] = state[5] & one_in;
    assign next_state[7] = (state[6] | state[7]) & one_in;
    assign next_state[8] = state[5] & zero_in;
    assign next_state[9] = state[6] & zero_in;

    // Output masks
    localparam [9:0] MASK_OUT1 = 10'b1100000000; // S8 and S9
    localparam [9:0] MASK_OUT2 = 10'b0100000000; // S7

    // Outputs computed as OR of masked states
    assign out1 = |(state & MASK_OUT1);
    assign out2 = |(state & MASK_OUT2);

endmodule