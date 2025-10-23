module TopModule (
    input  d,
    input  done_counting,
    input  ack,
    input  [9:0] state,  // one-hot encoding
    output B3_next,
    output S_next,
    output S1_next,
    output Count_next,
    output Wait_next,
    output done,
    output counting,
    output shift_ena
);

    // Current state
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

    // FSM controller
    wire [9:0] next_state;
    assign next_state = (
        // Transition from S to S1 or stay in S
        (S && d) ? 10'b0000000010 :
        (S && ~d) ? 10'b0000000001 :
        // Transition from S1 to S11 or back to S
        (S1 && d) ? 10'b0000000100 :
        (S1 && ~d) ? 10'b0000000001 :
        // Transition from S11 to S110 or stay in S11
        (S11 && d) ? 10'b0000001000 :
        (S11 && ~d) ? 10'b0000010000 :
        // Transition from S110 to B0 or back to S
        (S110 && d) ? 10'b0000100000 :
        (S110 && ~d) ? 10'b0000000001 :
        // Transition from B0 to B1
        (B0) ? 10'b0001000000 :
        // Transition from B1 to B2
        (B1) ? 10'b0010000000 :
        // Transition from B2 to B3
        (B2) ? 10'b0100000000 :
        // Transition from B3 to Count
        (B3) ? 10'b1000000000 :
        // Stay in Count if not done counting
        (Count && ~done_counting) ? 10'b1000000000 :
        // Transition from Count to Wait if done counting
        (Count && done_counting) ? 10'b0000000000 :
        // Stay in Wait if not acknowledged
        (Wait && ~ack) ? 10'b0000000000 :
        // Transition from Wait to S if acknowledged
        (Wait && ack) ? 10'b0000000001 : 10'bxxxxxxxxx
    );

    // Assign next state signals
    assign B3_next = next_state[7];
    assign S_next = next_state[0];
    assign S1_next = next_state[1];
    assign Count_next = next_state[8];
    assign Wait_next = next_state[9];

    // Output logic
    assign done = Wait;
    assign counting = Count;
    assign shift_ena = (B0 || B1 || B2 || B3);

endmodule