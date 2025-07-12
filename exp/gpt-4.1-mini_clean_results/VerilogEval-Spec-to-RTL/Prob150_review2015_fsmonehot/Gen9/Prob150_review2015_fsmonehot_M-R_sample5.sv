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

// State bits mapping (one-hot encoding)
// S     = state[0]
// S1    = state[1]
// S11   = state[2]
// S110  = state[3]
// B0    = state[4]
// B1    = state[5]
// B2    = state[6]
// B3    = state[7]
// Count = state[8]
// Wait  = state[9]

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

// Next state combinational logic as separate assigns

assign S_next = ((S | S1) & ~d) | (S110 & ~d) | (Wait & ack);
assign S1_next = S & d;
assign S11_next = (S1 | S11) & d;
assign S110_next = S11 & ~d;
assign B0_next = S110 & d;
assign B1_next = B0;
assign B2_next = B1;
assign B3_next = B2;
assign Count_next = B3 | (Count & ~done_counting);
assign Wait_next = (Count & done_counting) | (Wait & ~ack);

// Moore outputs from current state
assign done     = Wait;
assign counting = Count;
assign shift_ena= B0 | B1 | B2 | B3;

endmodule