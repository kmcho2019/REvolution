module TopModule (
    input d,
    input done_counting,
    input ack,
    input [9:0] state,  // One-hot encoding
    output B3_next,
    output S_next,
    output S1_next,
    output Count_next,
    output Wait_next,
    output done,
    output counting,
    output shift_ena
);

// State bit positions (one-hot encoding)
localparam S     = 0;
localparam S1    = 1;
localparam S11   = 2;
localparam S110  = 3;
localparam B0    = 4;
localparam B1    = 5;
localparam B2    = 6;
localparam B3    = 7;
localparam Count = 8;
localparam Wait  = 9;

// Current state extraction
wire S_curr     = state[S];
wire S1_curr    = state[S1];
wire S110_curr  = state[S110];
wire B2_curr    = state[B2];
wire B3_curr    = state[B3];
wire Count_curr = state[Count];
wire Wait_curr  = state[Wait];

// Next state logic
assign S_next = (S_curr & ~d) |         // S stays on d=0
                (S1_curr & ~d) |        // S1->S on d=0
                (S110_curr & ~d) |      // S110->S on d=0
                (Wait_curr & ack);      // Wait->S on ack=1

assign S1_next = S_curr & d;            // S->S1 on d=1

assign B3_next = B2_curr;               // B2 always goes to B3

assign Count_next = B3_curr |           // B3->Count
                   (Count_curr & ~done_counting); // Count stays until done

assign Wait_next = (Count_curr & done_counting) | // Count->Wait when done
                  (Wait_curr & ~ack);             // Wait stays until ack

// Output logic (Moore - depends only on current state)
assign shift_ena = state[B0] | state[B1] | state[B2] | state[B3];
assign counting  = state[Count];
assign done      = state[Wait];

endmodule