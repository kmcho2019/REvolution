module TopModule (
    input d,
    input done_counting,
    input ack,
    input [9:0] state,  // One-hot encoded state
    output B3_next,
    output S_next,
    output S1_next,
    output Count_next,
    output Wait_next,
    output done,
    output counting,
    output shift_ena
);

// Named state bit positions (one-hot encoding)
localparam S     = 0;
localparam S1    = 1;
localparam S11   = 2;
localparam S110  = 3;
localparam B0    = 4;
localparam B1    = 5;
localparam B2    = 6;
localparam B3    = 7;
localparam COUNT = 8;
localparam WAIT  = 9;

// Next state logic - optimized and documented
// S transitions (4 possible sources)
assign S_next = (state[S] & ~d) |         // S stays when d=0
                (state[S1] & ~d) |        // S1->S when d=0
                (state[S110] & ~d) |      // S110->S when d=0
                (state[WAIT] & ack);      // Wait->S when ack=1

// S1 transitions (only from S when d=1)
assign S1_next = state[S] & d;

// B3 transitions (only from B2)
assign B3_next = state[B2];

// Count transitions (from B3 or self-loop when not done)
assign Count_next = state[B3] |           // B3->Count always
                   (state[COUNT] & ~done_counting); // Count stays when not done

// Wait transitions (from Count when done or self-loop when no ack)
assign Wait_next = (state[COUNT] & done_counting) | // Count->Wait when done
                  (state[WAIT] & ~ack);   // Wait stays when no ack

// Output logic - minimal and direct
assign done      = state[WAIT];           // Active only in Wait state
assign counting  = state[COUNT];          // Active only in Count state
assign shift_ena = state[B0] | state[B1] | state[B2] | state[B3]; // Active in B states

endmodule