module TopModule (
    input        in,
    input  [9:0] state,
    output [9:0] next_state,
    output       out1,
    output       out2
);

    // Define 10 next-state vectors corresponding to transitions from each state.
    // Each vector has one bit set corresponding to the next state.
    // For each state, create two vectors: one for in=0, one for in=1.
    // Then accumulate contributions weighted by input conditions and current state bits.

    // Next state vectors for in=0 transitions:
    // S0(0) --0--> S0
    // S1(1) --0--> S0
    // S2(2) --0--> S0
    // S3(3) --0--> S0
    // S4(4) --0--> S0
    // S5(5) --0--> S8
    // S6(6) --0--> S9
    // S7(7) --0--> S0
    // S8(8) --0--> S0
    // S9(9) --0--> S0

    wire [9:0] next_from_state0_in0 = 10'b0000000001; // S0->S0
    wire [9:0] next_from_state1_in0 = 10'b0000000001; // S1->S0
    wire [9:0] next_from_state2_in0 = 10'b0000000001; // S2->S0
    wire [9:0] next_from_state3_in0 = 10'b0000000001; // S3->S0
    wire [9:0] next_from_state4_in0 = 10'b0000000001; // S4->S0
    wire [9:0] next_from_state5_in0 = 10'b0000010000; // S5->S8 (bit 8)
    wire [9:0] next_from_state6_in0 = 10'b0000100000; // S6->S9 (bit 9)
    wire [9:0] next_from_state7_in0 = 10'b0000000001; // S7->S0
    wire [9:0] next_from_state8_in0 = 10'b0000000001; // S8->S0
    wire [9:0] next_from_state9_in0 = 10'b0000000001; // S9->S0

    // Next state vectors for in=1 transitions:
    // S0(0) --1--> S1
    // S1(1) --1--> S2
    // S2(2) --1--> S3
    // S3(3) --1--> S4
    // S4(4) --1--> S5
    // S5(5) --1--> S6
    // S6(6) --1--> S7
    // S7(7) --1--> S7
    // S8(8) --1--> S1
    // S9(9) --1--> S1

    wire [9:0] next_from_state0_in1 = 10'b0000000010; // S0->S1 (bit1)
    wire [9:0] next_from_state1_in1 = 10'b0000000100; // S1->S2 (bit2)
    wire [9:0] next_from_state2_in1 = 10'b0000001000; // S2->S3 (bit3)
    wire [9:0] next_from_state3_in1 = 10'b0000010000; // S3->S4 (bit4)
    wire [9:0] next_from_state4_in1 = 10'b0000100000; // S4->S5 (bit5)
    wire [9:0] next_from_state5_in1 = 10'b0001000000; // S5->S6 (bit6)
    wire [9:0] next_from_state6_in1 = 10'b1000000000; // S6->S7 (bit7)
    wire [9:0] next_from_state7_in1 = 10'b1000000000; // S7->S7 (bit7)
    wire [9:0] next_from_state8_in1 = 10'b0000000010; // S8->S1 (bit1)
    wire [9:0] next_from_state9_in1 = 10'b0000000010; // S9->S1 (bit1)

    // Aggregate all contributions based on input 'in' and current 'state' bits

    wire [9:0] next_state_in0 =
          ({10{state[0]}} & next_from_state0_in0) |
          ({10{state[1]}} & next_from_state1_in0) |
          ({10{state[2]}} & next_from_state2_in0) |
          ({10{state[3]}} & next_from_state3_in0) |
          ({10{state[4]}} & next_from_state4_in0) |
          ({10{state[5]}} & next_from_state5_in0) |
          ({10{state[6]}} & next_from_state6_in0) |
          ({10{state[7]}} & next_from_state7_in0) |
          ({10{state[8]}} & next_from_state8_in0) |
          ({10{state[9]}} & next_from_state9_in0);

    wire [9:0] next_state_in1 =
          ({10{state[0]}} & next_from_state0_in1) |
          ({10{state[1]}} & next_from_state1_in1) |
          ({10{state[2]}} & next_from_state2_in1) |
          ({10{state[3]}} & next_from_state3_in1) |
          ({10{state[4]}} & next_from_state4_in1) |
          ({10{state[5]}} & next_from_state5_in1) |
          ({10{state[6]}} & next_from_state6_in1) |
          ({10{state[7]}} & next_from_state7_in1) |
          ({10{state[8]}} & next_from_state8_in1) |
          ({10{state[9]}} & next_from_state9_in1);

    // Final next_state output merges based on input
    assign next_state = in ? next_state_in1 : next_state_in0;

    // Output logic:
    // out1 = 1 when current state includes S8 or S9 (state[8] or state[9])
    // out2 = 1 when current state includes S7 or S9 (state[7] or state[9])

    assign out1 = state[8] | state[9];
    assign out2 = state[7] | state[9];

endmodule