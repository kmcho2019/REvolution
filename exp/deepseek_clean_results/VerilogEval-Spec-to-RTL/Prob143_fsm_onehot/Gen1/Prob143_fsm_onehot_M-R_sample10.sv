module TopModule (
    input in,
    input [9:0] state,
    output [9:0] next_state,
    output out1,
    output out2
);

// Next state logic for each possible current state
wire s0_next0 = state[0] & ~in;
wire s0_next1 = state[0] & in;

wire s1_next0 = state[1] & ~in;
wire s1_next2 = state[1] & in;

wire s2_next0 = state[2] & ~in;
wire s2_next3 = state[2] & in;

wire s3_next0 = state[3] & ~in;
wire s3_next4 = state[3] & in;

wire s4_next0 = state[4] & ~in;
wire s4_next5 = state[4] & in;

wire s5_next8 = state[5] & ~in;
wire s5_next6 = state[5] & in;

wire s6_next9 = state[6] & ~in;
wire s6_next7 = state[6] & in;

wire s7_next0 = state[7] & ~in;
wire s7_next7 = state[7] & in;

wire s8_next0 = state[8] & ~in;
wire s8_next1 = state[8] & in;

wire s9_next0 = state[9] & ~in;
wire s9_next1 = state[9] & in;

// Combine all next state possibilities
assign next_state[0] = s0_next0 | s1_next0 | s2_next0 | s3_next0 | s4_next0 | 
                       s7_next0 | s8_next0 | s9_next0;
assign next_state[1] = s0_next1 | s8_next1 | s9_next1;
assign next_state[2] = s1_next2;
assign next_state[3] = s2_next3;
assign next_state[4] = s3_next4;
assign next_state[5] = s4_next5;
assign next_state[6] = s5_next6;
assign next_state[7] = s6_next7 | s7_next7;
assign next_state[8] = s5_next8;
assign next_state[9] = s6_next9;

// Output logic
assign out1 = state[8] | state[9];
assign out2 = state[7] | state[9];

endmodule