module TopModule (
    input        in,
    input  [9:0] state,
    output [9:0] next_state,
    output       out1,
    output       out2
);

    // Masks for next states when input is 0 (in=0)
    // For each current state active, if in=0, next_state is as below:
    // S0->S0, S1->S0, S2->S0, S3->S0, S4->S0, S5->S8, S6->S9, S7->S0, S8->S0, S9->S0
    localparam [9:0] NS0_MASKS [9:0] = {
        10'b0000000001, // S0 next state if in=0 -> S0 (bit 0)
        10'b0000000001, // S1 -> S0
        10'b0000000001, // S2 -> S0
        10'b0000000001, // S3 -> S0
        10'b0000000001, // S4 -> S0
        10'b0000010000, // S5 -> S8 (bit 8)
        10'b0000100000, // S6 -> S9 (bit 9)
        10'b0000000001, // S7 -> S0
        10'b0000000001, // S8 -> S0
        10'b0000000001  // S9 -> S0
    };

    // Masks for next states when input is 1 (in=1)
    // S0->S1, S1->S2, S2->S3, S3->S4, S4->S5, S5->S6, S6->S7, S7->S7, S8->S1, S9->S1
    localparam [9:0] NS1_MASKS [9:0] = {
        10'b0000000010, // S0 -> S1 (bit 1)
        10'b0000000100, // S1 -> S2 (bit 2)
        10'b0000001000, // S2 -> S3 (bit 3)
        10'b0000010000, // S3 -> S4 (bit 4)
        10'b0000100000, // S4 -> S5 (bit 5)
        10'b0001000000, // S5 -> S6 (bit 6)
        10'b0010000000, // S6 -> S7 (bit 7)
        10'b0010000000, // S7 -> S7 (bit 7)
        10'b0000000010, // S8 -> S1 (bit 1)
        10'b0000000010  // S9 -> S1 (bit 1)
    };

    integer i;
    reg [9:0] next_state_0, next_state_1;

    always @(*) begin
        next_state_0 = 10'b0;
        next_state_1 = 10'b0;
        // Accumulate next states based on current states and input
        for (i=0; i<10; i=i+1) begin
            if(state[i]) begin
                next_state_0 = next_state_0 | NS0_MASKS[i];
                next_state_1 = next_state_1 | NS1_MASKS[i];
            end
        end
    end

    // Select next_state based on input
    assign next_state = in ? next_state_1 : next_state_0;

    // Outputs:
    // out1 = 1 for states S8(8) or S9(9)
    assign out1 = state[8] | state[9];

    // out2 = 1 for states S7(7) or S9(9)
    assign out2 = state[7] | state[9];

endmodule