module TopModule(
    input        in,
    input  [9:0] state,
    output [9:0] next_state,
    output       out1,
    output       out2
);

    wire zero_in = ~in;
    wire one_in  =  in;

    // Grouping states transitioning to S0 on input 0 to reduce fan-in
    wire to_S0_lower = state[0] | state[1] | state[2] | state[3] | state[4];
    wire to_S0_upper = state[7] | state[8] | state[9];
    // next_state[0] covers states that transition to S0 on 0 input
    assign next_state[0] = (to_S0_lower & zero_in) | (to_S0_upper & zero_in);

    // Other next_state bits: direct combinational assignments per FSM transitions
    assign next_state[1] = (state[0] | state[8] | state[9]) & one_in;
    assign next_state[2] = state[1] & one_in;
    assign next_state[3] = state[2] & one_in;
    assign next_state[4] = state[3] & one_in;
    assign next_state[5] = state[4] & one_in;
    assign next_state[6] = state[5] & one_in;
    assign next_state[7] = (state[6] | state[7]) & one_in;
    assign next_state[8] = state[5] & zero_in;
    assign next_state[9] = state[6] & zero_in;

    // Outputs computed via masked OR reduction for compactness and scalability
    // out1 = S8 or S9 active
    localparam [9:0] MASK_OUT1 = 10'b1100000000; // bits 8 and 9
    // out2 = S7 or S9 active
    localparam [9:0] MASK_OUT2 = 10'b100000000;  // bit 7 only
    assign out1 = |(state & MASK_OUT1);
    assign out2 = state[9] | state[7];  // equivalent to |(state & MASK_OUT2)

endmodule