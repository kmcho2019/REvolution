module TopModule (
    input in,
    input [9:0] state,
    output [9:0] next_state,
    output out1,
    output out2
);

// Common signals
wire in_n = ~in;

// Output logic
assign out1 = state[8] | state[9];  // S8 or S9
assign out2 = state[7] | state[9];  // S7 or S9

// Individual state transition conditions
wire s0_to_s0 = state[0] & in_n;
wire s0_to_s1 = state[0] & in;

wire s1_to_s0 = state[1] & in_n;
wire s1_to_s2 = state[1] & in;

wire s2_to_s0 = state[2] & in_n;
wire s2_to_s3 = state[2] & in;

wire s3_to_s0 = state[3] & in_n;
wire s3_to_s4 = state[3] & in;

wire s4_to_s0 = state[4] & in_n;
wire s4_to_s5 = state[4] & in;

wire s5_to_s8 = state[5] & in_n;
wire s5_to_s6 = state[5] & in;

wire s6_to_s9 = state[6] & in_n;
wire s6_to_s7 = state[6] & in;

wire s7_to_s0 = state[7] & in_n;
wire s7_to_s7 = state[7] & in;

wire s8_to_s0 = state[8] & in_n;
wire s8_to_s1 = state[8] & in;

wire s9_to_s0 = state[9] & in_n;
wire s9_to_s1 = state[9] & in;

// Combine all transition conditions for each next state
assign next_state[0] = s0_to_s0 | s1_to_s0 | s2_to_s0 | s3_to_s0 | 
                       s4_to_s0 | s7_to_s0 | s8_to_s0 | s9_to_s0;
assign next_state[1] = s0_to_s1 | s8_to_s1 | s9_to_s1;
assign next_state[2] = s1_to_s2;
assign next_state[3] = s2_to_s3;
assign next_state[4] = s3_to_s4;
assign next_state[5] = s4_to_s5;
assign next_state[6] = s5_to_s6;
assign next_state[7] = s6_to_s7 | s7_to_s7;
assign next_state[8] = s5_to_s8;
assign next_state[9] = s6_to_s9;

endmodule