module TopModule(
    input        in,
    input  [9:0] state,
    output reg [9:0] next_state,
    output        out1,
    output        out2
);

    localparam [9:0] MASK_OUT1 = 10'b1100000000; // S8 and S9
    localparam [9:0] MASK_OUT2 = (1 << 7) | (1 << 9); // S7 and S9

    always @(*) begin
        next_state = 10'b0;
        // Next state logic per FSM with one-hot encoding, handling multiple active states
        // next_state[0] on input 0: from S0,S1,S2,S3,S4,S7,S8,S9
        next_state[0] = ((state[0] | state[1] | state[2] | state[3] | state[4] |
                          state[7] | state[8] | state[9]) & ~in);

        // next_state[1]: on input 1 from S0,S8,S9
        next_state[1] = (state[0] | state[8] | state[9]) & in;

        // next_state[2]: on input 1 from S1
        next_state[2] = state[1] & in;

        // next_state[3]: on input 1 from S2
        next_state[3] = state[2] & in;

        // next_state[4]: on input 1 from S3
        next_state[4] = state[3] & in;

        // next_state[5]: on input 1 from S4
        next_state[5] = state[4] & in;

        // next_state[6]: on input 1 from S5
        next_state[6] = state[5] & in;

        // next_state[7]: on input 1 from S6,S7
        next_state[7] = (state[6] | state[7]) & in;

        // next_state[8]: on input 0 from S5
        next_state[8] = state[5] & ~in;

        // next_state[9]: on input 0 from S6
        next_state[9] = state[6] & ~in;
    end

    // Outputs are combinational reductions on current states masked by output masks
    assign out1 = |(state & MASK_OUT1);
    assign out2 = |(state & MASK_OUT2);

endmodule