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

    // Next-state logic equations
    assign B3_next = B2; // Direct assignment from B2 to B3
    assign S_next = (S && ~d) || (S1 && ~d) || (S110 && ~d) || (Wait && ack); // Simplified condition
    assign S1_next = d && S; // Direct assignment from S to S1 on 'd'
    assign Count_next = B3 || (Count && ~done_counting); // Simplified condition for Count
    assign Wait_next = (Count && done_counting) || (Wait && ~ack); // Simplified condition for Wait

    // Output logic equations
    assign done = Wait; // Direct assignment of 'done' from Wait
    assign counting = Count; // Direct assignment of 'counting' from Count
    assign shift_ena = B0 || B1 || B2 || B3; // Simplified condition for 'shift_ena'

endmodule