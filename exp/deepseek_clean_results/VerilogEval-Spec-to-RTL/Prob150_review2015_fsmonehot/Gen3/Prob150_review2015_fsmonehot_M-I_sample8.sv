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

    // State definitions (one-hot encoding)
    parameter S      = 10'b0000000001;
    parameter S1     = 10'b0000000010;
    parameter S11    = 10'b0000000100;
    parameter S110   = 10'b0000001000;
    parameter B0     = 10'b0000010000;
    parameter B1     = 10'b0000100000;
    parameter B2     = 10'b0001000000;
    parameter B3     = 10'b0010000000;
    parameter Count  = 10'b0100000000;
    parameter Wait   = 10'b1000000000;

    // Next state logic (improved)
    assign S_next = (~d & (state == S | state == S1 | state == S110)) | 
                   (state == Wait & ack);

    assign S1_next = d & (state == S | state == S1);

    assign B3_next = state == B2;

    assign Count_next = state == B3 | (state == Count & ~done_counting);

    assign Wait_next = state == Count & done_counting;

    // Output logic
    assign done = state == Wait;
    assign counting = state == Count;
    assign shift_ena = |state[B3:B0];  // More efficient bitwise OR for contiguous states

endmodule