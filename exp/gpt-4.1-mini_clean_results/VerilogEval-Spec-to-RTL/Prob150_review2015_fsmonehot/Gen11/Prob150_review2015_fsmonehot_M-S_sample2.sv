module TopModule(
    input  wire        d,
    input  wire        done_counting,
    input  wire        ack,
    input  wire [9:0]  state,        // one-hot encoding
    output wire        B3_next,
    output wire        S_next,
    output wire        S1_next,
    output wire        Count_next,
    output wire        Wait_next,
    output wire        done,
    output wire        counting,
    output wire        shift_ena
);

// One-hot encoded state signals for clarity
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

// Next state outputs derived directly:
assign S_next = (S & ~d) | (S1 & ~d) | (S110 & ~d) | (Wait & ack);
assign S1_next = S & d;
assign B3_next = B2;
assign Count_next = B3 | (Count & ~done_counting);
assign Wait_next = (Count & done_counting) | (Wait & ~ack);

// Moore outputs depend only on current state bits
assign done      = Wait;
assign counting  = Count;
assign shift_ena = B0 | B1 | B2 | B3;

endmodule