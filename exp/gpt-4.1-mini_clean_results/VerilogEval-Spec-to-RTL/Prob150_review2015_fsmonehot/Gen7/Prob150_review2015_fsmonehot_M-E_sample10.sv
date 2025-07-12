module TopModule(
    input  wire        d,
    input  wire        done_counting,
    input  wire        ack,
    input  wire [9:0]  state,        // one-hot encoded current state
    output wire        B3_next,
    output wire        S_next,
    output wire        S1_next,
    output wire        Count_next,
    output wire        Wait_next,
    output wire        done,
    output wire        counting,
    output wire        shift_ena
);

// Define one-hot state bit indices for clarity
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

// Extract current state bits
wire S    = state[S_bit];
wire S1   = state[S1_bit];
wire S11  = state[S11_bit];
wire S110 = state[S110_bit];
wire B0   = state[B0_bit];
wire B1   = state[B1_bit];
wire B2   = state[B2_bit];
wire B3   = state[B3_bit];
wire Count= state[Count_bit];
wire Wait = state[Wait_bit];

// Next state logic (one-hot) derived explicitly by case inspection

// Next S state:
// From S: d=0 -> S
// From S1: d=0 -> S
// From S110: d=0 -> S
// From Wait: ack=1 -> S
wire S_next_expr =
    (S   & ~d)      |
    (S1  & ~d)      |
    (S110 & ~d)     |
    (Wait & ack);

// Next S1 state:
// From S: d=1 -> S1
wire S1_next_expr =
    (S & d);

// Next S11 state:
// From S1: d=1 -> S11
// From S11: d=1 -> S11 (remain)
wire S11_next_expr =
    (S1 & d) |
    (S11 & d);

// Next S110 state:
// From S11: d=0 -> S110
wire S110_next_expr =
    (S11 & ~d);

// Next B0 state:
// From S110: d=1 -> B0
wire B0_next_expr =
    (S110 & d);

// Next B1 state:
// From B0: always -> B1
wire B1_next_expr =
    B0;

// Next B2 state:
// From B1: always -> B2
wire B2_next_expr =
    B1;

// Next B3 state:
// From B2: always -> B3
wire B3_next_expr =
    B2;

// Next Count state:
// From B3: always -> Count
// From Count: done_counting=0 -> Count (remain)
wire Count_next_expr =
    B3 |
    (Count & ~done_counting);

// Next Wait state:
// From Count: done_counting=1 -> Wait
// From Wait: ack=0 -> Wait (remain)
wire Wait_next_expr =
    (Count & done_counting) |
    (Wait & ~ack);

// Output signals (Moore outputs depend only on current state)
assign done      = Wait;
assign counting  = Count;
assign shift_ena = B0 | B1 | B2 | B3;

// Next state indicator outputs: assert when next state equals that state
assign B3_next    = B3_next_expr;
assign S_next     = S_next_expr;
assign S1_next    = S1_next_expr;
assign Count_next = Count_next_expr;
assign Wait_next  = Wait_next_expr;

endmodule