module TopModule (
    input d,
    input done_counting,
    input ack,
    input [9:0] state,
    output B3_next,
    output S_next,
    output S1_next,
    output Count_next,
    output Wait_next,
    output done,
    output counting,
    output shift_ena
);

// State group definitions
wire in_start_group = |state[3:0];  // S, S1, S11, S110
wire in_shift_group = |state[7:4];  // B0-B3
wire in_count_group = state[8];     // Count
wire in_wait_group = state[9];      // Wait

// Next state group calculations
wire next_start_group = (in_start_group & (~d | (state[3] & ~d))) | 
                       (in_wait_group & ack);
wire next_shift_group = (state[3] & d) | in_shift_group & ~state[7];
wire next_count_group = state[7] | (in_count_group & ~done_counting);
wire next_wait_group = (in_count_group & done_counting) | 
                      (in_wait_group & ~ack);

// Individual next state signals
assign S_next = next_start_group & 
               ((state[0] & ~d) | (state[1] & ~d) | (state[3] & ~d) | ack);
assign S1_next = next_start_group & state[0] & d;
assign B3_next = next_shift_group & state[6];
assign Count_next = next_count_group;
assign Wait_next = next_wait_group;

// Output logic - takes advantage of state grouping
assign shift_ena = in_shift_group;
assign counting = in_count_group;
assign done = in_wait_group;

// State transition verification logic (ensures one-hot)
wire [9:0] next_state = {
    next_wait_group & ~next_count_group & ~next_shift_group & ~next_start_group,
    next_count_group & ~next_shift_group & ~next_start_group,
    next_shift_group & state[6],  // B3
    next_shift_group & state[5],  // B2
    next_shift_group & state[4],  // B1
    next_shift_group & (state[3] & d | state[7]), // B0 or from B3
    next_start_group & ((state[2] & d) | (state[3] & d)), // S110->B0 or S11->S11
    next_start_group & ((state[1] & d) | (state[2] & ~d)), // S1->S11 or S11->S110
    next_start_group & ((state[0] & d) | (state[1] & ~d)), // S->S1 or S1->S
    next_start_group & ((state[0] & ~d) | (state[3] & ~d) | ack) // S, S110->S or Wait->S
};

endmodule