module TopModule (
    input in,
    input [9:0] state,
    output [9:0] next_state,
    output out1,
    output out2
);

// State group definitions
wire group_A = |state[4:0];  // S0-S4
wire group_B = |state[6:5];  // S5-S6
wire group_C = state[7];     // S7
wire group_D = |state[9:8];  // S8-S9

// Common transition signals
wire transition_to_S0 = ~in;
wire transition_to_S1 = in & (group_A | group_D);
wire transition_to_next = in & group_A;

// Next state logic using hierarchical approach
assign next_state[0] = transition_to_S0 | 
                      (state[5] & transition_to_S0) | 
                      (state[6] & transition_to_S0) | 
                      (group_C & transition_to_S0) | 
                      (group_D & transition_to_S0);

assign next_state[1] = transition_to_S1;

assign next_state[2] = state[1] & transition_to_next;
assign next_state[3] = state[2] & transition_to_next;
assign next_state[4] = state[3] & transition_to_next;
assign next_state[5] = state[4] & transition_to_next;

assign next_state[6] = state[5] & in;
assign next_state[7] = state[6] & in;
assign next_state[8] = state[5] & transition_to_S0;
assign next_state[9] = state[6] & transition_to_S0;

// Special case for S7 self-loop
assign next_state[7] = next_state[7] | (state[7] & in);

// Output logic based on state groups
assign out1 = group_D;  // S8 or S9
assign out2 = group_C | (state[9] & group_D);  // S7 or S9

endmodule