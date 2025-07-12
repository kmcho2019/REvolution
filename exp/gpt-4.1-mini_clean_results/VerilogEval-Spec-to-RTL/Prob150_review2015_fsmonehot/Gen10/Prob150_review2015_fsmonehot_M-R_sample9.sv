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

// One-hot encoded current state signals for convenience
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

// Next state output signals (only the requested next states)
assign S_next = (S & ~d)       // S->S on d=0
              | (S1 & ~d)      // S1->S on d=0
              | (S110 & ~d)    // S110->S on d=0
              | (Wait & ack);  // Wait->S on ack=1

assign S1_next = (S & d);      // S->S1 on d=1

assign B3_next = B2;           // B2->B3 always

assign Count_next = (B3)            // B3->Count always
                  | (Count & ~done_counting); // Count->Count if not done

assign Wait_next = (Count & done_counting) // Count->Wait on done_counting=1
                 | (Wait & ~ack);           // Wait->Wait if ack=0

// S11 next state and others are not requested as outputs; implicitly unused here.

// Calculate S1_next also implies S11 and B0, B1, B2 transitions handled internally,
// but since they aren't outputs, no need to expose their next state.

// Moore outputs from current state
assign done     = Wait;
assign counting = Count;
assign shift_ena= B0 | B1 | B2 | B3;

// Note: B0, B1, B2 used in shift_ena output but their next state signals are internal.

// No clock or reset here as module is combinational logic only per instruction.

endmodule