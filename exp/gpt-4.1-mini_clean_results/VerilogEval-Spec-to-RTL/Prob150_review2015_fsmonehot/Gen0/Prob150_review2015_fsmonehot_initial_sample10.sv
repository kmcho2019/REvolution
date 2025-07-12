module TopModule (
    input        d,
    input        done_counting,
    input        ack,
    input  [9:0] state, // one-hot encoded current state
    output       B3_next,
    output       S_next,
    output       S1_next,
    output       Count_next,
    output       Wait_next,
    output       done,
    output       counting,
    output       shift_ena
);

// Current state bits for readability
wire S    = state[0];
wire S1   = state[1];
wire S11  = state[2];
wire S110 = state[3];
wire B0   = state[4];
wire B1   = state[5];
wire B2   = state[6];
wire B3   = state[7];
wire Count = state[8];
wire Wait  = state[9];

// Next state logic derived by inspection:

// Next state is S:
// From S, if d=0 -> S
// From S1, if d=0 -> S
// From S110, if d=0 -> S
// From Wait, if ack=1 -> S
assign S_next = (S    & ~d) | 
                (S1   & ~d) | 
                (S110 & ~d) | 
                (Wait  & ack);

// Next state is S1:
// From S, if d=1 -> S1
assign S1_next = (S & d);

// Next state is S11:
// From S1, if d=1 -> S11
// From S11, if d=1 -> S11 (self-loop)
wire S11_next = (S1 & d) | (S11 & d);
// We don't output S11_next since not requested

// Next state is S110:
// From S11, if d=0 -> S110
assign wire S110_next = (S11 & ~d);
// Not requested output signal

// Next state is B0:
// From S110, if d=1 -> B0
assign wire B0_next = (S110 & d);
// Not requested output signal

// Next state is B1:
// From B0 unconditional next cycle -> B1
assign wire B1_next = B0;

// Next state is B2:
// From B1 unconditional next cycle -> B2
assign wire B2_next = B1;

// Next state is B3:
// From B2 unconditional next cycle -> B3
assign B3_next = B2;

// Next state is Count:
// From B3 unconditional next cycle -> Count
assign Count_next = B3;

// Next state is Count (self-loop) if done_counting=0
// Next state is Wait if done_counting=1
assign Wait_next = Count & done_counting;

// Outputs:
// shift_ena=1 in states B0, B1, B2, B3
assign shift_ena = B0 | B1 | B2 | B3;

// counting=1 in Count state
assign counting = Count;

// done=1 in Wait state
assign done = Wait;

endmodule