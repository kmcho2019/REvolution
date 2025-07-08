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

    // State encoding for readability
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

    // Next state logic for each next state signal:
    // S_next: next state is S
    assign S_next = 
        // From S with d=0
        (S    & ~d) |
        // From S1 with d=0
        (S1   & ~d) |
        // From S11 with d=0
        (S11  & ~d) |
        // From S110 with d=0
        (S110 & ~d) |
        // From Wait with ack=1
        (Wait  & ack);

    // S1_next: next state is S1
    assign S1_next = 
        // From S with d=1
        (S    & d);

    // S11_next: not explicitly asked but used internally
    // We do not output S11_next.

    // B3_next: next state is B3
    assign B3_next = 
        // From B2 always next to B3
        (B2);

    // Count_next: next state is Count
    assign Count_next = 
        // From B3 always next to Count
        (B3);

    // Wait_next: next state is Wait
    assign Wait_next = 
        // From Count when done_counting=1
        (Count & done_counting);

    // Outputs:
    // shift_ena=1 in B0,B1,B2,B3
    assign shift_ena = B0 | B1 | B2 | B3;

    // counting=1 in Count
    assign counting = Count;

    // done=1 in Wait
    assign done = Wait;

endmodule