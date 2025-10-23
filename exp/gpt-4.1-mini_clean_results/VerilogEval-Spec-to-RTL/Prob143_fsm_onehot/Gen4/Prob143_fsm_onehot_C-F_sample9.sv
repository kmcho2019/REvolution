module TopModule(
    input        in,
    input  [9:0] state,
    output [9:0] next_state,
    output       out1,
    output       out2
);

    // Next state logic: direct combinational assignments
    // Each next_state bit is high if any current state transitions to that state
    // according to the FSM with input 'in' and possibly multiple active states

    assign next_state[0] = (state[0] & ~in) | (state[1] & ~in) | (state[2] & ~in) | 
                           (state[3] & ~in) | (state[4] & ~in) | (state[7] & ~in) | 
                           (state[8] & ~in) | (state[9] & ~in);

    assign next_state[1] = (state[0] & in) | (state[8] & in) | (state[9] & in);
    assign next_state[2] = state[1] & in;
    assign next_state[3] = state[2] & in;
    assign next_state[4] = state[3] & in;
    assign next_state[5] = state[4] & in;
    assign next_state[6] = state[5] & in;
    assign next_state[7] = (state[6] & in) | (state[7] & in);
    assign next_state[8] = state[5] & ~in;
    assign next_state[9] = state[6] & ~in;

    // Outputs computed by ORing relevant current states
    // out1 is high if S8 or S9 active
    // out2 is high if S7 or S9 active

    localparam [9:0] MASK_OUT1 = (1 << 8) | (1 << 9);  // bits 8 and 9
    localparam [9:0] MASK_OUT2 = (1 << 7) | (1 << 9);  // bits 7 and 9

    assign out1 = |(state & MASK_OUT1);
    assign out2 = |(state & MASK_OUT2);

endmodule