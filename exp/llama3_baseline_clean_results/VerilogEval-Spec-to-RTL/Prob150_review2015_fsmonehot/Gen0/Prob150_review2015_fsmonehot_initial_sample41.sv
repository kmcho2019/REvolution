module TopModule(
    input  d,
    input  done_counting,
    input  ack,
    input  [9:0] state,  // one-hot encoded state
    output B3_next,
    output S_next,
    output S1_next,
    output Count_next,
    output Wait_next,
    output done,
    output counting,
    output shift_ena
);

// Decode the current state
wire S     = state[0];
wire S1    = state[1];
wire S11   = state[2];
wire S110  = state[3];
wire B0    = state[4];
wire B1    = state[5];
wire B2    = state[6];
wire B3    = state[7];
wire Count = state[8];
wire Wait  = state[9];

// Next-state logic
assign B3_next = (S110 & d) | (B2);  // next state is B3
assign S_next  = (S & ~d) | (S1 & ~d) | (S110 & ~d) | (Wait & ack);  // next state is S
assign S1_next = (S & d);  // next state is S1
assign Count_next = (B3);  // next state is Count
assign Wait_next = (Count & done_counting);  // next state is Wait

// Output logic
assign done     = Wait;  // output done
assign counting = Count;  // output counting
assign shift_ena = B0 | B1 | B2 | B3;  // output shift_ena

endmodule