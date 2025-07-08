module TopModule(
    input        d,
    input        done_counting,
    input        ack,
    input [9:0]  state,
    output       B3_next,
    output       S_next,
    output       S1_next,
    output       Count_next,
    output       Wait_next,
    output       done,
    output       counting,
    output       shift_ena
);

// State bits for readability
wire S    = state[0];
wire S1   = state[1];
wire S11  = state[2];
wire S110 = state[3];
wire B0   = state[4];
wire B1   = state[5];
wire B2   = state[6];
wire B3   = state[7];
wire Count= state[8];
wire Wait = state[9];

// Next-state logic

// S_next: next state is S (bit0)
assign S_next = (S   & ~d)       // S --d=0--> S
              | (S1  & ~d)       // S1 --d=0--> S
              | (S110 & ~d)      // S110 --d=0--> S
              | (Wait & ack);    // Wait --ack=1--> S

// S1_next: next state is S1 (bit1)
assign S1_next = (S & d);         // S --d=1--> S1

// S11_next: next state is S11 (bit2)
assign S11_next = (S1 & d);       // S1 --d=1--> S11

// S110_next: next state is S110 (bit3)
assign S110_next = (S11 & ~d);    // S11 --d=0--> S110

// B0_next: next state is B0 (bit4)
assign B3_next = (B2);            // B2 always --> B3

assign B3_next = (B2);            // B2 always --> B3

// B0_next
wire B0_next = (S110 & d);        // S110 --d=1--> B0

// B1_next
wire B1_next = B0;                // B0 --> B1

// B2_next
wire B2_next = B1;                // B1 --> B2

// B3_next
assign B3_next = B2;              // B2 --> B3

// Count_next
assign Count_next = B3           // B3 --> Count
                  | (Count & ~done_counting); // Count --done_counting=0--> Count

// Wait_next
assign Wait_next = (Count & done_counting)  // Count --done_counting=1--> Wait
                 | (Wait & ~ack);            // Wait --ack=0--> Wait

// shift_ena = 1 when current state is B0, B1, B2, or B3
assign shift_ena = B0 | B1 | B2 | B3;

// counting = 1 when current state is Count
assign counting = Count;

// done = 1 when current state is Wait
assign done = Wait;

// We also need to output B3_next, S_next, S1_next, Count_next, Wait_next as per problem

// To avoid conflicting assignments to B3_next, reassign carefully:

// B3_next (next state == B3) occurs only from B2 unconditionally
// So B3_next = B2

// Final outputs:

endmodule