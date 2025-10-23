module TopModule(
    input        in,
    input  [9:0] state,
    output [9:0] next_state,
    output       out1,
    output       out2
);

    wire zero_in = ~in;
    wire one_in  =  in;

    // Group states that transition to S0 on input 0 to reduce fan-in and logic duplication
    wire s0_trans_to_0 = state[0] | state[1] | state[2] | state[3] | state[4] | state[7] | state[8] | state[9];

    assign next_state[0] = s0_trans_to_0 & zero_in;

    // Other next_state bits direct from FSM transitions
    assign next_state[1] = (state[0] | state[8] | state[9]) & one_in;
    assign next_state[2] = state[1] & one_in;
    assign next_state[3] = state[2] & one_in;
    assign next_state[4] = state[3] & one_in;
    assign next_state[5] = state[4] & one_in;
    assign next_state[6] = state[5] & one_in;
    assign next_state[7] = (state[6] | state[7]) & one_in;
    assign next_state[8] = state[5] & zero_in;
    assign next_state[9] = state[6] & zero_in;

    // Outputs as per FSM: out1 is high if state is S8 or S9, out2 is high if state is S7 or S9
    localparam [9:0] MASK_OUT1 = 10'b1100000000; // bits 8 and 9
    localparam [9:0] MASK_OUT2 = 10'b1000000000; // bit 7 and 9; we also need bit 7 => position 7: 0b0100000000
    // Correct MASK_OUT2: bits 7 and 9
    localparam [9:0] MASK_OUT2_corrected = (1 << 7) | (1 << 9);

    assign out1 = |(state & MASK_OUT1);
    assign out2 = |(state & MASK_OUT2_corrected);

endmodule