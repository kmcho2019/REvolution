module TopModule (
    input d,
    input done_counting,
    input ack,
    input [9:0] state,  // Original one-hot encoding (maintained for interface)
    output B3_next,
    output S_next,
    output S1_next,
    output Count_next,
    output Wait_next,
    output done,
    output counting,
    output shift_ena
);

// Hybrid state encoding interpretation
wire [1:0] seq_state = state[3:0] == 4'b0001 ? 2'b00 :  // S
                      state[3:0] == 4'b0010 ? 2'b01 :  // S1
                      state[3:0] == 4'b0100 ? 2'b10 :  // S11
                      state[3:0] == 4'b1000 ? 2'b11 : 2'b00; // S110

wire [3:0] op_state = state[9:4];  // One-hot for B0-B3, Count, Wait

// Next state logic for sequence detection (priority encoded)
wire next_S = (seq_state == 2'b00 && ~d) ||  // S->S
              (seq_state == 2'b01 && ~d) ||  // S1->S
              (seq_state == 2'b11 && ~d) ||  // S110->S
              (op_state[5] && ack);         // Wait->S

wire next_S1 = (seq_state == 2'b00 && d);    // S->S1

wire next_S11 = (seq_state == 2'b01 && d) || // S1->S11
               (seq_state == 2'b10 && d);    // S11->S11

wire next_S110 = (seq_state == 2'b10 && ~d); // S11->S110

wire next_B0 = (seq_state == 2'b11 && d);    // S110->B0

// Operational state transitions (one-hot)
wire next_B1 = op_state[0];  // B0->B1
wire next_B2 = op_state[1];  // B1->B2
wire next_B3 = op_state[2];  // B2->B3
wire next_Count = op_state[3] || (op_state[4] && ~done_counting); // B3->Count or Count->Count
wire next_Wait = (op_state[4] && done_counting) || (op_state[5] && ~ack); // Count->Wait or Wait->Wait

// Output assignments
assign S_next = next_S;
assign S1_next = next_S1;
assign B3_next = next_B3;
assign Count_next = next_Count;
assign Wait_next = next_Wait;

assign shift_ena = |op_state[3:0];  // B0-B3
assign counting = op_state[4];      // Count
assign done = op_state[5];          // Wait

endmodule