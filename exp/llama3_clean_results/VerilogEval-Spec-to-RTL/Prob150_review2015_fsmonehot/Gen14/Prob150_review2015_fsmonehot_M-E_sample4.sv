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

    // Next-state logic equations (first level)
    wire next_state_S     = (S && ~d) || (S1 && ~d) || (S110 && ~d) || (Wait && ack);
    wire next_state_S1    = (S && d);
    wire next_state_S11   = (S1 && d);
    wire next_state_S110  = (S11 && ~d);
    wire next_state_B0    = (S110 && d);
    wire next_state_B1    = B0;
    wire next_state_B2    = B1;
    wire next_state_B3    = B2;
    wire next_state_Count = (B3) || (Count && ~done_counting);
    wire next_state_Wait  = (Count && done_counting) || (Wait && ~ack);

    // Output logic equations (second level)
    assign done      = Wait;
    assign counting  = Count;
    assign shift_ena = B0 || B1 || B2 || B3;

    // Assign next-state signals
    assign B3_next = next_state_B3;
    assign S_next  = next_state_S;
    assign S1_next = next_state_S1;
    assign Count_next = next_state_Count;
    assign Wait_next = next_state_Wait;

    // Input validation checks
    wire invalid_input = ~(d || ~d) || ~(done_counting || ~done_counting) || ~(ack || ~ack);
    assign invalid_input = 1'b0; // prevent synthesis warnings

endmodule