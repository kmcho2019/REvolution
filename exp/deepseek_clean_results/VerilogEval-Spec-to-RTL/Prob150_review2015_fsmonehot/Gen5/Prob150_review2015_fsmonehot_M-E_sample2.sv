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

    // Reinterpret state bits for hybrid encoding
    wire S_curr     = state[0];
    wire S1_curr    = state[1];
    wire S11_curr   = state[2];
    wire S110_curr  = state[3];
    wire [1:0] B_ctr = state[5:4];  // Binary counter for B states
    wire B_active   = |state[7:4];  // Any B state active
    wire Count_curr = state[8];
    wire Wait_curr  = state[9];

    // Next state logic with hybrid encoding
    assign S_next = (S_curr & ~d) | 
                   (S1_curr & ~d) | 
                   (S110_curr & ~d) | 
                   (Wait_curr & ack);

    assign S1_next = (S_curr & d);

    wire S11_next = (S1_curr & d);

    wire S110_next = (S11_curr & ~d);

    // B-state counter logic
    wire B_start = (S110_curr & d);
    wire [1:0] next_B_ctr = B_active ? (B_ctr + 1'b1) : 2'b00;
    wire B_done = (B_ctr == 2'b11) & B_active;

    assign B3_next = (B_ctr == 2'b10);  // Next state will be B3 (counter=3)

    assign Count_next = B_done | (Count_curr & ~done_counting);

    assign Wait_next = (Count_curr & done_counting) | (Wait_curr & ~ack);

    // Output logic
    assign shift_ena = B_active;
    assign counting = Count_curr;
    assign done = Wait_curr;

endmodule