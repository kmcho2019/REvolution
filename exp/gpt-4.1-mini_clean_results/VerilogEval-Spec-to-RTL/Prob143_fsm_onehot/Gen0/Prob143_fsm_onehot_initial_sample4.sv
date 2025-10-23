module TopModule(
    input        in,
    input  [9:0] state,
    output [9:0] next_state,
    output       out1,
    output       out2
);

// For each state, define the next state for in=0 and in=1, and outputs
// S0 (0,0) --0--> S0, --1--> S1
wire [9:0] ns_S0 = (in == 1'b0) ? 10'b0000000001 : 10'b0000000010; // S0 or S1
wire out1_S0 = 1'b0;
wire out2_S0 = 1'b0;

// S1 (0,0) --0--> S0, --1--> S2
wire [9:0] ns_S1 = (in == 1'b0) ? 10'b0000000001 : 10'b0000000100; // S0 or S2
wire out1_S1 = 1'b0;
wire out2_S1 = 1'b0;

// S2 (0,0) --0--> S0, --1--> S3
wire [9:0] ns_S2 = (in == 1'b0) ? 10'b0000000001 : 10'b0000001000; // S0 or S3
wire out1_S2 = 1'b0;
wire out2_S2 = 1'b0;

// S3 (0,0) --0--> S0, --1--> S4
wire [9:0] ns_S3 = (in == 1'b0) ? 10'b0000000001 : 10'b0000010000; // S0 or S4
wire out1_S3 = 1'b0;
wire out2_S3 = 1'b0;

// S4 (0,0) --0--> S0, --1--> S5
wire [9:0] ns_S4 = (in == 1'b0) ? 10'b0000000001 : 10'b0000100000; // S0 or S5
wire out1_S4 = 1'b0;
wire out2_S4 = 1'b0;

// S5 (0,0) --0--> S8, --1--> S6
wire [9:0] ns_S5 = (in == 1'b0) ? 10'b1000000000 : 10'b0100000000; // S8 or S6
wire out1_S5 = 1'b0;
wire out2_S5 = 1'b0;

// S6 (0,0) --0--> S9, --1--> S7
wire [9:0] ns_S6 = (in == 1'b0) ? 10'b1000000000 : 10'b0010000000; // S9 or S7 (indices 9 or 7)
wire ns_S6_0 = (in == 1'b0); // For clarity
wire [9:0] ns_S6_0_state = 10'b1000000000; // S9
wire [9:0] ns_S6_1_state = 10'b0010000000; // S7
wire [9:0] ns_S6_comb = (in == 1'b0) ? ns_S6_0_state : ns_S6_1_state;

// Note corrected above to ns_S6

wire [9:0] ns_S6_fixed = (in == 1'b0) ? 10'b1000000000 : 10'b0010000000; // S9 or S7

wire out1_S6 = 1'b0;
wire out2_S6 = 1'b0;

// S7 (0,1) --0--> S0, --1--> S7; outputs (0,1)
wire [9:0] ns_S7 = (in == 1'b0) ? 10'b0000000001 : 10'b0010000000; // S0 or S7
wire out1_S7 = 1'b0;
wire out2_S7 = 1'b1;

// S8 (1,0) --0--> S0, --1--> S1; outputs (1,0)
wire [9:0] ns_S8 = (in == 1'b0) ? 10'b0000000001 : 10'b0000000010; // S0 or S1
wire out1_S8 = 1'b1;
wire out2_S8 = 1'b0;

// S9 (1,1) --0--> S0, --1--> S1; outputs (1,1)
wire [9:0] ns_S9 = (in == 1'b0) ? 10'b0000000001 : 10'b0000000010; // S0 or S1
wire out1_S9 = 1'b1;
wire out2_S9 = 1'b1;

// For all states, use input state vector to select transitions and outputs

wire [9:0] next_state_from_S0 = state[0] ? ns_S0 : 10'b0;
wire [9:0] next_state_from_S1 = state[1] ? ns_S1 : 10'b0;
wire [9:0] next_state_from_S2 = state[2] ? ns_S2 : 10'b0;
wire [9:0] next_state_from_S3 = state[3] ? ns_S3 : 10'b0;
wire [9:0] next_state_from_S4 = state[4] ? ns_S4 : 10'b0;
wire [9:0] next_state_from_S5 = state[5] ? ns_S5 : 10'b0;
wire [9:0] next_state_from_S6 = state[6] ? ns_S6_fixed : 10'b0;
wire [9:0] next_state_from_S7 = state[7] ? ns_S7 : 10'b0;
wire [9:0] next_state_from_S8 = state[8] ? ns_S8 : 10'b0;
wire [9:0] next_state_from_S9 = state[9] ? ns_S9 : 10'b0;

// Aggregate next_state
assign next_state = next_state_from_S0 | next_state_from_S1 | next_state_from_S2 | 
                    next_state_from_S3 | next_state_from_S4 | next_state_from_S5 |
                    next_state_from_S6 | next_state_from_S7 | next_state_from_S8 |
                    next_state_from_S9;

// Aggregate outputs (OR of all active states outputs)
wire out1_s = (state[8] & out1_S8) | (state[9] & out1_S9);
wire out2_s = (state[7] & out2_S7) | (state[9] & out2_S9);

assign out1 = out1_s;
assign out2 = out2_s;

endmodule