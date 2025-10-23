module TopModule (
    input  d,
    input  done_counting,
    input  ack,
    input  [9:0] state,  // Hybrid encoding
    output B3_next,
    output S_next,
    output S1_next,
    output Count_next,
    output Wait_next,
    output done,
    output counting,
    output shift_ena
);

    // Define states for binary-encoded part (3 bits for 8 states, but we only need 4)
    wire [1:0] seq_state = state[9:8];  // S, S1, S11, S110
    wire S     = seq_state == 2'b00;
    wire S1    = seq_state == 2'b01;
    wire S11   = seq_state == 2'b10;
    wire S110  = seq_state == 2'b11;

    // One-hot encoded states for shifting and counting
    wire B0    = state[7];
    wire B1    = state[6];
    wire B2    = state[5];
    wire B3    = state[4];
    wire Count = state[3];
    wire Wait  = state[2];

    // Next-state logic for binary-encoded part
    wire [1:0] next_seq_state;
    assign next_seq_state = (d == 0) ? (seq_state == 2'b00) ? 2'b00 : (seq_state == 2'b01) ? 2'b00 : (seq_state == 2'b10) ? 2'b11 : 2'b00 :
                                                  (seq_state == 2'b00) ? 2'b01 : (seq_state == 2'b01) ? 2'b10 : (seq_state == 2'b10) ? 2'b10 : 2'b11;

    // Next-state logic for one-hot encoded part
    assign B3_next = B2;  // Direct transition
    assign S_next = (ack && Wait) || (seq_state == 2'b00 && d == 0);  // Simplified condition
    assign S1_next = (seq_state == 2'b00 && d == 1);  // Direct transition
    assign Count_next = (B3 || (~done_counting && Count));  // Reduced redundancy
    assign Wait_next = (done_counting && Count) || (~ack && Wait);  // Simplified condition

    // Output logic
    assign done = Wait;  // Direct assignment
    assign counting = Count;  // Direct assignment
    assign shift_ena = (B0 || B1 || B2 || B3);  // Simplified condition

endmodule