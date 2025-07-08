module TopModule (
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

// One-hot state bits for clarity
wire S    = state[0];
wire S1   = state[1];
wire S11  = state[2];
wire S110 = state[3];
wire B0   = state[4];
wire B1   = state[5];
wire B2   = state[6];
wire B3_s = state[7];
wire Count= state[8];
wire Wait = state[9];

// Next state logic bits (one-hot)
wire S_next_w;
wire S1_next_w;
wire S11_next_w;
wire S110_next_w;
wire B0_next_w;
wire B1_next_w;
wire B2_next_w;
wire B3_next_w;
wire Count_next_w;
wire Wait_next_w;

// From state S
assign S_next_w   = (S & ~d)                 // S --d=0--> S
                 | (S1 & ~d)                 // S1 --d=0--> S
                 | (S110 & ~d)               // S110 --d=0--> S
                 | (Wait & ack);             // Wait --ack=1--> S

// From state S1
assign S1_next_w  = (S & d)                  // S --d=1--> S1
                 | (S1 & d);                 // S1 --d=1--> S11 but S11_next_w covers that

// From state S11
assign S11_next_w = (S1 & d)                  // S1 --d=1--> S11
                 | (S11 & d);                 // S11 --d=1--> S11

// From state S110
assign S110_next_w= (S11 & ~d);               // S11 --d=0--> S110

// From state B0
assign B0_next_w  = (S110 & d);               // S110 --d=1--> B0

// From state B1
assign B1_next_w  = B0;                        // B0 always -> B1

// From state B2
assign B2_next_w  = B1;                        // B1 always -> B2

// From state B3
assign B3_next_w  = B2;                        // B2 always -> B3

// From state Count
assign Count_next_w= (B3_s)                   // B3 always -> Count
                  | (Count & ~done_counting);// Count --done_counting=0--> Count

// From state Wait
assign Wait_next_w = (Count & done_counting)  // Count --done_counting=1--> Wait
                  | (Wait & ~ack);            // Wait --ack=0--> Wait

// Outputs
assign done     = Wait;
assign counting = Count;
assign shift_ena= B0 | B1 | B2 | B3_s;

// Assign requested outputs
assign B3_next   = B3_next_w;
assign S_next    = S_next_w;
assign S1_next   = S1_next_w;
assign Count_next= Count_next_w;
assign Wait_next = Wait_next_w;

endmodule