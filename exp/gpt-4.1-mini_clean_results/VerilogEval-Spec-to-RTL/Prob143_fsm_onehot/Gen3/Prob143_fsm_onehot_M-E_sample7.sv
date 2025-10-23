module TopModule (
    input        in,
    input  [9:0] state,
    output [9:0] next_state,
    output       out1,
    output       out2
);

    // For each next_state bit, determine which states transition to it given input
    
    // next_state[0] = any state active that transitions to S0 on input
    // According to FSM:
    // S0 --0--> S0
    // S1 --0--> S0
    // S2 --0--> S0
    // S3 --0--> S0
    // S4 --0--> S0
    // S7 --0--> S0
    // S8 --0--> S0
    // S9 --0--> S0
    // So next_state[0] = (in==0) & (S0|S1|S2|S3|S4|S7|S8|S9)
    // S7 --0--> S0
    // S8 --0--> S0
    // S9 --0--> S0
    // Also note S5 and S6 input=0 transitions don't go to S0 but to S8 and S9 respectively.

    // next_state[1]: states transitioning to S1
    // S0 --1--> S1
    // S8 --1--> S1
    // S9 --1--> S1

    // next_state[2]: 
    // S1 --1--> S2

    // next_state[3]:
    // S2 --1--> S3

    // next_state[4]:
    // S3 --1--> S4

    // next_state[5]:
    // S4 --1--> S5

    // next_state[6]:
    // S5 --1--> S6

    // next_state[7]:
    // S6 --1--> S7
    // S7 --1--> S7

    // next_state[8]:
    // S5 --0--> S8

    // next_state[9]:
    // S6 --0--> S9

    // We create bit masks of states that transition to each next_state bit when input=0 and input=1.

    // Masks for input=0 transitions (for next_state bits):
    // next_state[0] input=0 from states: S0(0),S1(1),S2(2),S3(3),S4(4),S7(7),S8(8),S9(9)
    localparam [9:0] NS0_0 = (1<<0) | (1<<1) | (1<<2) | (1<<3) | (1<<4) | (1<<7) | (1<<8) | (1<<9);
    // next_state[8] input=0 from S5
    localparam [9:0] NS8_0 = (1<<5);
    // next_state[9] input=0 from S6
    localparam [9:0] NS9_0 = (1<<6);

    // Masks for input=1 transitions (for next_state bits):
    // next_state[1] input=1 from S0,S8,S9
    localparam [9:0] NS1_1 = (1<<0) | (1<<8) | (1<<9);
    // next_state[2] input=1 from S1
    localparam [9:0] NS2_1 = (1<<1);
    // next_state[3] input=1 from S2
    localparam [9:0] NS3_1 = (1<<2);
    // next_state[4] input=1 from S3
    localparam [9:0] NS4_1 = (1<<3);
    // next_state[5] input=1 from S4
    localparam [9:0] NS5_1 = (1<<4);
    // next_state[6] input=1 from S5
    localparam [9:0] NS6_1 = (1<<5);
    // next_state[7] input=1 from S6,S7
    localparam [9:0] NS7_1 = (1<<6) | (1<<7);

    // For next_state[0] we must consider input==0 and corresponding states
    wire ns0 = (~in) & (| (state & NS0_0));

    // For next_state[1]
    wire ns1 = ( in) & (| (state & NS1_1));

    // next_state[2]
    wire ns2 = ( in) & (| (state & NS2_1));

    // next_state[3]
    wire ns3 = ( in) & (| (state & NS3_1));

    // next_state[4]
    wire ns4 = ( in) & (| (state & NS4_1));

    // next_state[5]
    wire ns5 = ( in) & (| (state & NS5_1));

    // next_state[6]
    wire ns6 = ( in) & (| (state & NS6_1));

    // next_state[7]
    wire ns7 = ( in) & (| (state & NS7_1));

    // next_state[8]
    wire ns8 = (~in) & (| (state & NS8_0));

    // next_state[9]
    wire ns9 = (~in) & (| (state & NS9_0));

    assign next_state = {ns9, ns8, ns7, ns6, ns5, ns4, ns3, ns2, ns1, ns0};

    // Outputs: 
    // out1 = 1 if state S8 or S9 active
    assign out1 = |(state & ((1<<8) | (1<<9)));
    // out2 = 1 if state S7 or S9 active
    assign out2 = |(state & ((1<<7) | (1<<9)));

endmodule