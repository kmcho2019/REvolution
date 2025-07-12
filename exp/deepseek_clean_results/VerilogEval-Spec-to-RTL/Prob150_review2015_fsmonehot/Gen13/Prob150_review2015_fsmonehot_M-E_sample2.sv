module TopModule (
    input d,
    input done_counting,
    input ack,
    input [9:0] state,
    output B3_next,
    output S_next,
    output S1_next,
    output Count_next,
    output Wait_next,
    output done,
    output counting,
    output shift_ena
);

    // Priority-based next state logic
    assign S_next = state[9] ? ack :         // Wait -> S if ack
                   state[3] ? ~d :           // S110 -> S if d=0
                   state[1] ? ~d :          // S1 -> S if d=0
                   state[0] ? ~d : 0;        // S -> S if d=0

    assign S1_next = state[0] & d;           // S -> S1 if d=1

    assign B3_next = state[6];               // B2 -> B3 always

    assign Count_next = state[7] ? 1 :       // B3 -> Count
                       state[8] ? ~done_counting : 0; // Count -> Count if not done

    assign Wait_next = state[8] ? done_counting :    // Count -> Wait if done
                      state[9] ? ~ack : 0;           // Wait -> Wait if no ack

    // Output logic - direct from state bits
    assign done = state[9];
    assign counting = state[8];
    assign shift_ena = |state[7:4];  // B0-B3 states

endmodule