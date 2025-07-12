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

    // Reinterpret state bits with mixed encoding
    // Bits [5:0] - one-hot for S, S1, S11, S110, Count, Wait
    // Bits [7:6] - binary for B states (00=B0, 01=B1, 10=B2, 11=B3)
    wire S_curr    = state[0];
    wire S1_curr   = state[1];
    wire S11_curr  = state[2];
    wire S110_curr = state[3];
    wire Count_curr= state[4];
    wire Wait_curr = state[5];
    wire [1:0] B_state = state[7:6];
    wire B0_curr = (B_state == 2'b00) & (|state[7:6]);
    wire B1_curr = (B_state == 2'b01);
    wire B2_curr = (B_state == 2'b10);
    wire B3_curr = (B_state == 2'b11);

    // Next state logic with hierarchical encoding
    assign S_next = (S_curr & ~d) | 
                   (S1_curr & ~d) | 
                   (S110_curr & ~d) | 
                   (Wait_curr & ack);

    assign S1_next = (S_curr & d);

    wire S11_next = (S1_curr & d);
    wire S110_next = (S11_curr & ~d);

    // Binary-encoded B state progression
    wire B_next_valid = S110_curr & d;
    wire [1:0] B_next_state = B_state + 1'b1;
    assign B3_next = (B_state == 2'b10);  // Next state will be B3 (11)

    assign Count_next = (B_state == 2'b11) | (Count_curr & ~done_counting);
    assign Wait_next = (Count_curr & done_counting) | (Wait_curr & ~ack);

    // Output logic
    assign shift_ena = (|state[7:6]);  // Any B state
    assign counting = Count_curr;
    assign done = Wait_curr;

    // Additional outputs for original state bits (maintain compatibility)
    assign S1_next = (S_curr & d);
    assign Count_next = (B_state == 2'b11) | (Count_curr & ~done_counting);
    assign Wait_next = (Count_curr & done_counting) | (Wait_curr & ~ack);

endmodule