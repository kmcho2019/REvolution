module TopModule(
    input  wire       d,
    input  wire       done_counting,
    input  wire       ack,
    input  wire [9:0] state,        // one-hot encoding
    output wire       B3_next,
    output wire       S_next,
    output wire       S1_next,
    output wire       Count_next,
    output wire       Wait_next,
    output wire       done,
    output wire       counting,
    output wire       shift_ena
);

localparam S_bit     = 0,
           S1_bit    = 1,
           S11_bit   = 2,
           S110_bit  = 3,
           B0_bit    = 4,
           B1_bit    = 5,
           B2_bit    = 6,
           B3_bit    = 7,
           Count_bit = 8,
           Wait_bit  = 9;

wire S     = state[S_bit];
wire S1    = state[S1_bit];
wire S11   = state[S11_bit];
wire S110  = state[S110_bit];
wire B0    = state[B0_bit];
wire B1    = state[B1_bit];
wire B2    = state[B2_bit];
wire B3    = state[B3_bit];
wire Count = state[Count_bit];
wire Wait  = state[Wait_bit];

assign S_next = (S & ~d) | (S1 & ~d) | (S110 & ~d) | (Wait & ack);
assign S1_next = S & d;
assign Count_next = B3 | (Count & ~done_counting);
assign Wait_next = (Count & done_counting) | (Wait & ~ack);
assign B3_next = B2;
assign shift_ena = B0 | B1 | B2 | B3;
assign done = Wait;
assign counting = Count;

endmodule