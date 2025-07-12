module TopModule (
    input d,
    input done_counting,
    input ack,
    input [9:0] state,  // Original one-hot input for compatibility
    output B3_next,
    output S_next,
    output S1_next,
    output Count_next,
    output Wait_next,
    output done,
    output counting,
    output shift_ena
);

    // Internal state representation using hybrid encoding
    wire [3:0] int_state;
    assign int_state = 
        state[0] ? 4'b0001 :  // S
        state[1] ? 4'b0010 :  // S1
        state[2] ? 4'b0011 :  // S11
        state[3] ? 4'b0100 :  // S110
        state[4] ? 4'b1001 :  // B0
        state[5] ? 4'b1010 :  // B1
        state[6] ? 4'b1011 :  // B2
        state[7] ? 4'b1100 :  // B3
        state[8] ? 4'b0101 : // Count
        4'b0110;              // Wait

    // Next state logic using hybrid encoding
    assign S_next = (int_state == 4'b0001 & ~d) |      // S->S
                   (int_state == 4'b0010 & ~d) |      // S1->S
                   (int_state == 4'b0100 & ~d) |      // S110->S
                   (int_state == 4'b0110 & ack);      // Wait->S

    assign S1_next = (int_state == 4'b0001 & d);      // S->S1

    assign B3_next = (int_state == 4'b1011);          // B2->B3

    assign Count_next = (int_state == 4'b1100) |      // B3->Count
                      (int_state == 4'b0101 & ~done_counting); // Count->Count

    assign Wait_next = (int_state == 4'b0101 & done_counting) | // Count->Wait
                      (int_state == 4'b0110 & ~ack);           // Wait->Wait

    // Output logic remains simple as in one-hot
    assign shift_ena = (int_state[3:2] == 2'b10);  // B0-B3 states (1001-1100)
    assign counting = (int_state == 4'b0101);      // Count state
    assign done = (int_state == 4'b0110);          // Wait state

endmodule