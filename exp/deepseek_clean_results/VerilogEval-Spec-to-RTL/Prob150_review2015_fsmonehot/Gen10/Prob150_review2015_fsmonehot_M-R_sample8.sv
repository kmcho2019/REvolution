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

    // Next state logic using case statement
    assign S_next = (state == 10'b0000000001 && ~d) ||  // S->S
                    (state == 10'b0000000010 && ~d) ||  // S1->S
                    (state == 10'b0000000100 && ~d) ||  // S11->S110
                    (state == 10'b0000001000 && ~d) ||  // S110->S
                    (state == 10'b1000000000 && ack);   // Wait->S

    assign S1_next = (state == 10'b0000000001 && d);    // S->S1

    assign B3_next = (state == 10'b0000100000);         // B2->B3

    assign Count_next = (state == 10'b0001000000) ||    // B3->Count
                        (state == 10'b0100000000 && ~done_counting); // Count->Count

    assign Wait_next = (state == 10'b0100000000 && done_counting) || // Count->Wait
                       (state == 10'b1000000000 && ~ack);            // Wait->Wait

    // Output logic
    assign done = (state == 10'b1000000000);            // Wait state
    assign counting = (state == 10'b0100000000);        // Count state
    assign shift_ena = (state == 10'b0000010000) ||     // B0 state
                       (state == 10'b0000100000) ||     // B1 state
                       (state == 10'b0001000000) ||      // B2 state
                       (state == 10'b0010000000);       // B3 state

endmodule