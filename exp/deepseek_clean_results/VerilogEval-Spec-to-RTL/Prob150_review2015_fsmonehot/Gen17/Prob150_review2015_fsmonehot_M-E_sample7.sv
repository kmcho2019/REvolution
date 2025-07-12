module TopModule (
    input d,
    input done_counting,
    input ack,
    input [9:0] state,  // Maintain original interface for compatibility
    output B3_next,
    output S_next,
    output S1_next,
    output Count_next,
    output Wait_next,
    output done,
    output counting,
    output shift_ena
);

    // Internal state representation (7 bits: 2 category + 5 one-hot)
    wire [1:0] category = state[9] ? 2'b11 :          // Wait
                         state[8] ? 2'b10 :           // Count
                         (|state[7:4]) ? 2'b01 :      // Bit Shift
                         2'b00;                       // Sequence

    wire [4:0] seq_state = state[3:0];  // S, S1, S11, S110

    // Next state logic
    wire next_is_S = (category == 2'b00 && ((seq_state[0] & ~d) || 
                     (seq_state[1] & ~d) || (seq_state[3] & ~d))) ||
                    (category == 2'b11 && ack);

    wire next_is_S1 = (category == 2'b00 && seq_state[0] & d);
    wire next_is_B0 = (category == 2'b00 && seq_state[3] & d);
    wire next_is_Count = (category == 2'b01 && state[7]) ||  // B3->Count
                        (category == 2'b10 && ~done_counting); // Count->Count

    // Output next state signals
    assign S_next = next_is_S;
    assign S1_next = next_is_S1;
    assign B3_next = (category == 2'b01 && state[6]);  // B2->B3
    assign Count_next = next_is_Count;
    assign Wait_next = (category == 2'b10 && done_counting) ||  // Count->Wait
                      (category == 2'b11 && ~ack);              // Wait->Wait

    // Output logic
    assign shift_ena = (category == 2'b01);  // All Bit Shift states
    assign counting = (category == 2'b10);   // Count state
    assign done = (category == 2'b11);       // Wait state
endmodule