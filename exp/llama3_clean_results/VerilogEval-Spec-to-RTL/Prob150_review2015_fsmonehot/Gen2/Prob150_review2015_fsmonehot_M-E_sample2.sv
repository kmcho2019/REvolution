module TopModule(
    input  d,
    input  done_counting,
    input  ack,
    input  [9:0] state, // One-hot encoded state
    output B3_next,
    output S_next,
    output S1_next,
    output Count_next,
    output Wait_next,
    output done,
    output counting,
    output shift_ena
);

// Decode current state
wire [9:0] curr_state = state;

// Next-state logic using multiplexers
wire next_state_S  = (curr_state[0] & ~d) | (curr_state[1] & ~d) | (curr_state[3] & ~d) | (curr_state[9] & ack);
wire next_state_S1 = curr_state[0] & d;
wire next_state_B3 = curr_state[7];
wire next_state_Count = (curr_state[7] & ~done_counting) | (curr_state[6] & 1'b1);
wire next_state_Wait = curr_state[5] & done_counting;

// Output logic using logic gates
wire shift_ena_wire = curr_state[4] | curr_state[5] | curr_state[6] | curr_state[7];
wire counting_wire = curr_state[5];
wire done_wire = curr_state[9];

// Assign outputs
assign B3_next = next_state_B3;
assign S_next  = next_state_S;
assign S1_next = next_state_S1;
assign Count_next = next_state_Count;
assign Wait_next = next_state_Wait;
assign shift_ena = shift_ena_wire;
assign counting = counting_wire;
assign done = done_wire;

endmodule