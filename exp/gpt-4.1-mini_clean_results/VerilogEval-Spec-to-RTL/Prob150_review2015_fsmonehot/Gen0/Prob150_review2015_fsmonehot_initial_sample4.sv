module TopModule(
    input        d,
    input        done_counting,
    input        ack,
    input  [9:0] state,        // One-hot: bit0=S, bit1=S1, ..., bit9=Wait
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
wire Count = state[8];
wire Wait  = state[9];

// Next state logic (one-hot)
assign S_next = (S    & ~d)     // S with d=0 -> S
              | (S1   & ~d)     // S1 d=0 -> S
              | (S110  & ~d)    // S110 d=0 -> S
              | (Wait & ack);   // Wait ack=1 -> S

assign S1_next = S & d;          // S d=1 -> S1

assign // Intermediate states used for completeness but not output ports:
       S11_next = (S1  & d) | (S11 & d);

assign S110_next = S11 & ~d;

assign // B0 next from S110 d=1
       B0_next = S110 & d;

assign // B1 next from B0 always
       B1_next = B0;

assign // B2 next from B1 always
       B2_next = B1;

assign // B3 next from B2 always
       B3_next = B2;

assign Count_next = (B3) 
                  | (Count & ~done_counting);

assign Wait_next = Count & done_counting
                 | (Wait & ~ack);

// Outputs from current state (Moore machine)
assign shift_ena = B0 | B1 | B2 | B3;
assign counting  = Count;
assign done      = Wait;

endmodule