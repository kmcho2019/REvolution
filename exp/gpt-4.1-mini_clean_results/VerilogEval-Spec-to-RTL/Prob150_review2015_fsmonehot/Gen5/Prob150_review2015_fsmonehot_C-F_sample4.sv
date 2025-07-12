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

// One-hot state bit indices
localparam S_bit     = 0;
localparam S1_bit    = 1;
localparam S11_bit   = 2;
localparam S110_bit  = 3;
localparam B0_bit    = 4;
localparam B1_bit    = 5;
localparam B2_bit    = 6;
localparam B3_bit    = 7;
localparam Count_bit = 8;
localparam Wait_bit  = 9;

// Extract current state signals
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

// Next-state combinational logic (one-hot next states)
assign S_next = (S    & ~d)        // From S with d=0
              | (S1   & ~d)        // From S1 with d=0
              | (S110  & ~d)       // From S110 with d=0
              | (Wait  &  ack);    // From Wait with ack=1

assign S1_next = (S & d);           // From S with d=1

assign S11_next = (S1  & d)
                | (S11 & d);

assign S110_next = (S11 & ~d);

assign B0_next = (S110 & d);

assign B1_next = B0;                // Always next

assign B2_next = B1;                // Always next

assign B3_next = B2;                // Always next

assign Count_next = (B3)
                  | (Count & ~done_counting);

assign Wait_next = (Count & done_counting)
                 | (Wait  & ~ack);

// Moore outputs based on current state
assign done     = Wait;
assign counting = Count;
assign shift_ena = B0 | B1 | B2 | B3;

endmodule