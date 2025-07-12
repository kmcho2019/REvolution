module TopModule(
    input  wire        d,
    input  wire        done_counting,
    input  wire        ack,
    input  wire [9:0]  state,       // one-hot encoding: bit0=S, bit1=S1, ..., bit9=Wait
    output wire        B3_next,
    output wire        S_next,
    output wire        S1_next,
    output wire        Count_next,
    output wire        Wait_next,
    output wire        done,
    output wire        counting,
    output wire        shift_ena
);

// State bit positions for one-hot encoding
localparam S_BIT     = 0;
localparam S1_BIT    = 1;
localparam S11_BIT   = 2;
localparam S110_BIT  = 3;
localparam B0_BIT    = 4;
localparam B1_BIT    = 5;
localparam B2_BIT    = 6;
localparam B3_BIT    = 7;
localparam COUNT_BIT = 8;
localparam WAIT_BIT  = 9;

// Current state signals
wire S    = state[S_BIT];
wire S1   = state[S1_BIT];
wire S11  = state[S11_BIT];
wire S110 = state[S110_BIT];
wire B0   = state[B0_BIT];
wire B1   = state[B1_BIT];
wire B2   = state[B2_BIT];
wire B3   = state[B3_BIT];
wire COUNT= state[COUNT_BIT];
wire WAIT = state[WAIT_BIT];

// Next state signals, one per state bit position
wire next_S;
wire next_S1;
wire next_S11;
wire next_S110;
wire next_B0;
wire next_B1;
wire next_B2;
wire next_B3;
wire next_COUNT;
wire next_WAIT;

// Next state logic derived by case inspection and one-hot progression

// From S state:
assign next_S   = (S & ~d)         // S stays in S on d=0
                  | (S110 & ~d)    // S110->S on d=0
                  | (S1 & ~d)      // S1->S on d=0
                  | (WAIT & ack);  // Wait->S on ack=1

// From S1 state:
assign next_S1  = (S & d);         // S->S1 on d=1

// From S11 state:
assign next_S11 = (S1 & d)         // S1->S11 on d=1
                  | (S11 & d);    // S11 stays on d=1

// From S110 state:
assign next_S110 = (S11 & ~d);    // S11->S110 on d=0

// From B0 state:
assign next_B0  = (S110 & d);     // S110->B0 on d=1

// From B1 state:
assign next_B1  = B0;             // B0->B1 on next clock

// From B2 state:
assign next_B2  = B1;             // B1->B2 on next clock

// From B3 state:
assign next_B3  = B2;             // B2->B3 on next clock

// From Count state:
assign next_COUNT = (B3)                 // B3->Count on next clock
                    | (COUNT & ~done_counting); // Count remains if not done

// From Wait state:
assign next_WAIT  = (COUNT & done_counting)  // Count->Wait if done
                    | (WAIT & ~ack);          // Wait remains until ack=1

// Output logic (Moore outputs depend on current state only)
assign shift_ena = B0 | B1 | B2 | B3;
assign counting  = COUNT;
assign done      = WAIT;

// Output the next state signals of interest (asserted when next-state is that state)
assign S_next     = next_S;
assign S1_next    = next_S1;
assign B3_next    = next_B3;
assign Count_next = next_COUNT;
assign Wait_next  = next_WAIT;

endmodule