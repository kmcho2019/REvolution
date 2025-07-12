module TopModule(
    input  wire        d,
    input  wire        done_counting,
    input  wire        ack,
    input  wire [9:0]  state,
    output wire        B3_next,
    output wire        S_next,
    output wire        S1_next,
    output wire        Count_next,
    output wire        Wait_next,
    output wire        done,
    output wire        counting,
    output wire        shift_ena
);

// State bit positions in one-hot encoding
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

// Extract current states for clarity
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

// Next state logic derived by explicit transitions

// Next S state:
// From S if d=0 -> S
// From S1 if d=0 -> S
// From S110 if d=0 -> S
// From Wait if ack=1 -> S
assign S_next = (S & ~d) 
              | (S1 & ~d) 
              | (S110 & ~d) 
              | (Wait & ack);

// Next S1 state:
// From S if d=1 -> S1
assign S1_next = S & d;

// Next S11 state:
// From S1 if d=1 -> S11
// From S11 if d=1 -> S11 (loop)
wire S11_next = (S1 & d) | (S11 & d);

// Next S110 state:
// From S11 if d=0 -> S110
assign wire_S11_d0 = S11 & ~d;
wire S110_next = wire_S11_d0;

// Next B0 state:
// From S110 if d=1 -> B0
assign B0_next = S110 & d;

// B1 next state from B0 (always next cycle)
assign B1_next = B0;

// B2 next state from B1 (always next cycle)
assign B2_next = B1;

// B3 next state from B2 (always next cycle)
assign B3_next = B2;

// Count next state:
// From B3 -> Count
// From Count if done_counting=0 -> Count (loop)
assign Count_next = B3 | (Count & ~done_counting);

// Wait next state:
// From Count if done_counting=1 -> Wait
// From Wait if ack=0 -> Wait (loop)
assign Wait_next = (Count & done_counting) | (Wait & ~ack);

// Output signals for Moore machine
assign done     = Wait;
assign counting = Count;
assign shift_ena= B0 | B1 | B2 | B3;

// Assign missing next state bits (S11 and S110) for completeness of combinational logic (not outputs)
wire S11_next_wire = S11_next;
wire S110_next_wire = S110_next;

// S11_next and S110_next are internal signals and not outputs, so not exposed in module ports

endmodule