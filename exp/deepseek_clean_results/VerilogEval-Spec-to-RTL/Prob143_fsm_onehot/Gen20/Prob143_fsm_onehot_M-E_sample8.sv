module TopModule (
    input in,
    input [9:0] state,
    output [9:0] next_state,
    output out1,
    output out2
);

// State group detection
wire in_lower_states = |state[4:0];  // S0-S4
wire in_upper_states = |state[9:5];  // S5-S9

// Transition logic for lower states (S0-S4)
wire [4:0] lower_next;
assign lower_next[0] = (state[0] & ~in) |         // S0 stays on 0
                      (|state[4:1] & ~in);       // S1-S4 -> S0 on 0
assign lower_next[1] = (state[0] & in) |          // S0 -> S1
                      (state[1] & in);           // S1 -> S2 (via next_state[2])
assign lower_next[2] = state[1] & in;             // S1 -> S2
assign lower_next[3] = state[2] & in;             // S2 -> S3
assign lower_next[4] = state[3] & in;             // S3 -> S4

// Transition logic for upper states (S5-S9)
wire [4:0] upper_next;
assign upper_next[0] = state[4] & in;             // S4 -> S5 (special case)
assign upper_next[1] = state[5] & in;             // S5 -> S6
assign upper_next[2] = (state[6] & in) |          // S6 -> S7
                      (state[7] & in);           // S7 stays
assign upper_next[3] = state[5] & ~in;            // S5 -> S8
assign upper_next[4] = state[6] & ~in;            // S6 -> S9

// Combine next state outputs with priority encoding
assign next_state[0] = lower_next[0] | (in_upper_states & ~in);
assign next_state[1] = lower_next[1] | (state[8] & in) | (state[9] & in);
assign next_state[2] = lower_next[2];
assign next_state[3] = lower_next[3];
assign next_state[4] = lower_next[4];
assign next_state[5] = upper_next[0];
assign next_state[6] = upper_next[1];
assign next_state[7] = upper_next[2];
assign next_state[8] = upper_next[3];
assign next_state[9] = upper_next[4];

// Output logic with priority encoding (handles multiple active states)
assign out1 = |state[9:8];  // S8 or S9
assign out2 = |(state & 10'b0001001000);  // S7 or S9

endmodule