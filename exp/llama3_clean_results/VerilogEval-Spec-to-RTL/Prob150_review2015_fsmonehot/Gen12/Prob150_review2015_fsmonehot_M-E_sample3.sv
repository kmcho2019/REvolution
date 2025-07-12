module TopModule (
    input  d,
    input  done_counting,
    input  ack,
    input  [9:0] state,  // hybrid encoding
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
    wire [1:0] simple_state = state[1:0];  // one-hot encoding for S, S1, S11, S110
    wire [3:0] complex_state = state[9:6];  // binary encoding for B0, B1, B2, B3, Count, Wait

    // Next-state logic equations
    assign B3_next = (complex_state == 4'b0011);  // B3
    assign S_next = (simple_state == 2'b01 && ~d) || (complex_state == 4'b1000 && ack);  // S
    assign S1_next = (simple_state == 2'b01 && d);  // S1
    assign Count_next = (complex_state == 4'b0100) || (complex_state == 4'b0011 && ~done_counting);  // Count
    assign Wait_next = (complex_state == 4'b1000 && ~ack) || (complex_state == 4'b0100 && done_counting);  // Wait

    // Output logic equations
    assign done = (complex_state == 4'b1000);  // Wait
    assign counting = (complex_state == 4'b0100);  // Count
    assign shift_ena = (complex_state >= 4'b0010 && complex_state <= 4'b0011);  // B0, B1, B2, B3

endmodule