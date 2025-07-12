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

    // Decompose the state machine into smaller parts
    wire data_processing_state;
    wire counting_waiting_state;

    // Data processing part
    assign data_processing_state = (S || S1 || S11 || S110);
    assign S_next = (data_processing_state && (~d && (S || S1 || S110))) || (Wait && ack);
    assign S1_next = (data_processing_state && d && S);
    assign S1_next = (data_processing_state && d && S);

    // Counting and waiting part
    assign counting_waiting_state = (B0 || B1 || B2 || B3 || Count || Wait);
    assign Count_next = (counting_waiting_state && ((B3) || (Count && ~done_counting)));
    assign Wait_next = (counting_waiting_state && ((Count && done_counting) || (Wait && ~ack)));

    // Output logic equations
    assign done = Wait;
    assign counting = Count;
    assign shift_ena = (B0 || B1 || B2 || B3);

    // B3_next is asserted when the next state is B3
    assign B3_next = (counting_waiting_state && B2);

endmodule