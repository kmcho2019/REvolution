module TopModule(
    input        in,
    input  [9:0] state,
    output [9:0] next_state,
    output       out1,
    output       out2
);

    wire zero_in = ~in;
    wire one_in  =  in;

    // Next state bit vectors for input=0 transitions: which states lead to each next_state on zero input
    // For each next state bit position, indicate which current states transition there on input=0
    wire [9:0] next0 = {
        // S9 to next states on 0: S9->S0
        // S8 to next states on 0: S8->S0
        // S7 to next states on 0: S7->S0
        // S6 to next states on 0: S6->S9
        // S5 to next states on 0: S5->S8
        // S4 to next states on 0: S4->S0
        // S3 to next states on 0: S3->S0
        // S2 to next states on 0: S2->S0
        // S1 to next states on 0: S1->S0
        // S0 to next states on 0: S0->S0

        // Index 9 (S9) = no transition on zero input to S9, only from S6->S9 (done below)
        1'b0,      // bit 9: next_state[9]
        1'b0,      // bit 8: next_state[8]
        1'b0,      // bit 7: next_state[7]
        1'b0,      // bit 6: next_state[6]
        1'b0,      // bit 5: next_state[5]
        1'b0,      // bit 4: next_state[4]
        1'b0,      // bit 3: next_state[3]
        1'b0,      // bit 2: next_state[2]
        1'b0,      // bit 1: next_state[1]
        1'b1       // bit 0: next_state[0]
    };

    // The above only marks next_state[0] = 1 for zero transitions from many states
    // But we need to expand it into multiple bits since next0[0] should be 1 if current state in {S0,S1,S2,S3,S4,S7,S8,S9} and input=0
    // So we create one-hot mask vectors for all states that transit to S0 on input=0:

    // Create mask vectors for zero input transitions per next state
    localparam [9:0] ZERO_TO_S0 = 10'b0001111101; // states S0(0),S1(1),S2(2),S3(3),S4(4),S7(7),S8(8),S9(9)
    localparam [9:0] ZERO_TO_S8 = 10'b0010000000; // S5->S8 on zero_in
    localparam [9:0] ZERO_TO_S9 = 10'b0100000000; // S6->S9 on zero_in

    // Next state bit vectors for input=1 transitions: which states lead to each next_state on one input
    // Define for next_state[1] to next_state[7] based on transitions
    // According to the FSM, on input=1:
    // S0->S1, S1->S2, S2->S3, S3->S4, S4->S5, S5->S6, S6->S7, S7->S7

    // We create masks for states that transit to each next_state on input=1:
    localparam [9:0] ONE_TO_S1 = 10'b0000000001; // S0->S1
    localparam [9:0] ONE_TO_S2 = 10'b0000000010; // S1->S2
    localparam [9:0] ONE_TO_S3 = 10'b0000000100; // S2->S3
    localparam [9:0] ONE_TO_S4 = 10'b0000001000; // S3->S4
    localparam [9:0] ONE_TO_S5 = 10'b0000010000; // S4->S5
    localparam [9:0] ONE_TO_S6 = 10'b0000100000; // S5->S6
    localparam [9:0] ONE_TO_S7 = 10'b0110000000; // S6->S7 and S7->S7 (S6=6, S7=7)

    // Calculate each next_state bit by ANDing current states with corresponding masks, then ORing results per next state:
    wire ns0_zero = |(state & ZERO_TO_S0) & zero_in;
    wire ns8_zero = |(state & ZERO_TO_S8) & zero_in;
    wire ns9_zero = |(state & ZERO_TO_S9) & zero_in;

    wire ns1_one = |(state & ONE_TO_S1) & one_in;
    wire ns2_one = |(state & ONE_TO_S2) & one_in;
    wire ns3_one = |(state & ONE_TO_S3) & one_in;
    wire ns4_one = |(state & ONE_TO_S4) & one_in;
    wire ns5_one = |(state & ONE_TO_S5) & one_in;
    wire ns6_one = |(state & ONE_TO_S6) & one_in;
    wire ns7_one = |(state & ONE_TO_S7) & one_in;

    assign next_state = {
        ns9_zero, // bit 9: S9
        ns8_zero, // bit 8: S8
        ns7_one,  // bit 7: S7
        ns6_one,  // bit 6: S6
        ns5_one,  // bit 5: S5
        ns4_one,  // bit 4: S4
        ns3_one,  // bit 3: S3
        ns2_one,  // bit 2: S2
        ns1_one,  // bit 1: S1
        ns0_zero  // bit 0: S0
    };

    // Define output masks: S8 and S9 produce out1=1, S7 and S9 produce out2=1
    localparam [9:0] OUT1_MASK = 10'b1100000000; // S8=8, S9=9
    localparam [9:0] OUT2_MASK = 10'b0100000000 | 10'b1000000000; // S7=7 and S9=9 => 10'b0100000000 + 10'b1000000000 = 10'b1100000000 is same as out1 mask?
    // Wait out2 is 1 for S7 and S9:
    // S7 is bit 7 = 1<<7 = 0x80, S9 is 1<<9=0x200, so OUT2_MASK = (1<<7)|(1<<9) = 10'b1010000000
    localparam [9:0] OUT2_MASK_CORRECT = (1 << 7) | (1 << 9);

    assign out1 = |(state & OUT1_MASK);
    assign out2 = |(state & OUT2_MASK_CORRECT);

endmodule