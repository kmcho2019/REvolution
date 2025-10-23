module TopModule(
    input  wire        d,
    input  wire        done_counting,
    input  wire        ack,
    input  wire [9:0]  state,        // one-hot encoding: S=bit0, S1=bit1, ..., Wait=bit9
    output wire        B3_next,
    output wire        S_next,
    output wire        S1_next,
    output wire        Count_next,
    output wire        Wait_next,
    output wire        done,
    output wire        counting,
    output wire        shift_ena
);

// Direct state bit access by index for clarity
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

// Next state logic
assign S_next     = ((S | S1 | S110) & ~d) | (Wait & ack);
assign S1_next    = S & d;
assign B3_next    = B2;
assign Count_next = B3 | (Count & ~done_counting);
assign Wait_next  = (Count & done_counting) | (Wait & ~ack);

// S11_next, S110_next, B0_next and others are not outputs and not required here

// Outputs
assign done      = Wait;
assign counting  = Count;
assign shift_ena = B0 | B1 | B2 | B3;

endmodule