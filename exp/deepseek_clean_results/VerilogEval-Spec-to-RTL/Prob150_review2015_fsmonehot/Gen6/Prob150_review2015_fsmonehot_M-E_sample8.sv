module TopModule (
    input d,
    input done_counting,
    input ack,
    input [9:0] state,
    output B3_next,
    output S_next,
    output S1_next,
    output Count_next,
    output Wait_next,
    output done,
    output counting,
    output shift_ena
);

// Hybrid encoding:
// [3:0] - Sequence states (priority encoded)
// [6:4] - B states (one-hot)
// [7]   - Count
// [8]   - Wait

// Sequence states
wire in_S    = state[0];
wire in_S1   = state[1];
wire in_S11  = state[2];
wire in_S110 = state[3];

// B states
wire in_B0 = state[4];
wire in_B1 = state[5];
wire in_B2 = state[6];
wire in_B3 = state[7];

// Operational states
wire in_Count = state[8];
wire in_Wait  = state[9];

// Sequence detection logic (priority encoded)
wire seq_detected = in_S110 & d;
wire seq_S1_next  = in_S & d;
wire seq_S11_next = in_S1 & d;
wire seq_S110_next= in_S11 & ~d;
wire seq_reset    = (in_S & ~d) | (in_S1 & ~d) | (in_S110 & ~d) | (in_Wait & ack);

// B state progression
wire b_progress = in_B0 | in_B1 | in_B2;

// Count/Wait transitions
wire count_hold = in_Count & ~done_counting;
wire count_done = in_Count & done_counting;
wire wait_hold  = in_Wait & ~ack;

// Next state logic with priority
assign S_next    = seq_reset;
assign S1_next   = seq_S1_next & ~seq_reset;
assign B3_next   = in_B2;
assign Count_next= (in_B3 | count_hold) & ~count_done;
assign Wait_next = count_done | wait_hold;

// Output logic with pipelining
reg shift_ena_reg;
always @(*) begin
    shift_ena_reg = in_B0 | in_B1 | in_B2 | in_B3;
end

assign shift_ena = shift_ena_reg;
assign counting  = in_Count;
assign done      = in_Wait;

// Additional optimization: Early shift_ena termination
wire shift_ena_early = |state[4:7];  // B0-B3

endmodule