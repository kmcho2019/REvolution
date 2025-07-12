module TopModule(
    input  wire        d,
    input  wire        done_counting,
    input  wire        ack,
    input  wire [9:0]  state,       // one-hot encoded states
    output wire        B3_next,
    output wire        S_next,
    output wire        S1_next,
    output wire        Count_next,
    output wire        Wait_next,
    output wire        done,
    output wire        counting,
    output wire        shift_ena
);

// Define state bit indices for clarity
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

// Extract each current state bit
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

// Intermediate wires for next states based on inputs and current states
wire next_S_from_S      = S     & (~d);
wire next_S_from_S1     = S1    & (~d);
wire next_S_from_S110   = S110  & (~d);
wire next_S_from_Wait   = Wait   & ack;

wire next_S1_from_S     = S     & d;

wire next_S11_from_S1   = S1    & d;
wire next_S11_from_S11  = S11   & d;

wire next_S110_from_S11 = S11   & (~d);

wire next_B0_from_S110  = S110  & d;

wire next_B1_from_B0    = B0;

wire next_B2_from_B1    = B1;

wire next_B3_from_B2    = B2;

wire next_Count_from_B3          = B3;
wire next_Count_from_Count       = Count & (~done_counting);

wire next_Wait_from_Count        = Count & done_counting;
wire next_Wait_from_Wait         = Wait  & (~ack);

// Assign next-state output signals
assign S_next     = next_S_from_S | next_S_from_S1 | next_S_from_S110 | next_S_from_Wait;
assign S1_next    = next_S1_from_S;
assign B3_next    = next_B3_from_B2;
assign Count_next = next_Count_from_B3 | next_Count_from_Count;
assign Wait_next  = next_Wait_from_Count | next_Wait_from_Wait;

// For S11 and B states except B3, outputs not requested, but computed here internally
// S11 and S110, B0, B1, B2 next states not output ports as per spec so not declared

// Output logic (Moore outputs depend on current state only)
assign done      = Wait;
assign counting  = Count;
assign shift_ena = B0 | B1 | B2 | B3;

endmodule