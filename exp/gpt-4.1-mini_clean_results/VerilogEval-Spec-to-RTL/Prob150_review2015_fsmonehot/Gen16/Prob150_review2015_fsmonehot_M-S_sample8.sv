module TopModule(
    input  wire        d,
    input  wire        done_counting,
    input  wire        ack,
    input  wire [9:0]  state,  // one-hot: bit0=S ... bit9=Wait
    output wire        B3_next,
    output wire        S_next,
    output wire        S1_next,
    output wire        Count_next,
    output wire        Wait_next,
    output wire        done,
    output wire        counting,
    output wire        shift_ena
);

// Next state logic derived from one-hot state bits (S=bit0, S1=bit1, ..., Wait=bit9)
assign S_next     = ((state[0] | state[1] | state[3]) & ~d) | (state[9] & ack);
assign S1_next    = state[0] & d;
assign B3_next    = state[6];
assign Count_next = state[7] | (state[8] & ~done_counting);
assign Wait_next  = (state[8] & done_counting) | (state[9] & ~ack);

// Outputs from current state (Moore outputs)
assign done      = state[9];
assign counting  = state[8];
assign shift_ena = state[4] | state[5] | state[6] | state[7];

endmodule