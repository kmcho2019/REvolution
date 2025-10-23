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

    // Next state logic using always block
    reg [9:0] next_state;
    always @(*) begin
        casez (state)
            10'b0000000001: next_state = d ? 10'b0000000010 : 10'b0000000001; // S
            10'b0000000010: next_state = d ? 10'b0000000100 : 10'b0000000001; // S1
            10'b0000000100: next_state = d ? 10'b0000000100 : 10'b0000010000; // S11
            10'b0000010000: next_state = d ? 10'b0000100000 : 10'b0000000001; // S110
            10'b0000100000: next_state = 10'b0001000000; // B0
            10'b0001000000: next_state = 10'b0010000000; // B1
            10'b0010000000: next_state = 10'b0100000000; // B2
            10'b0100000000: next_state = 10'b1000000000; // B3
            10'b1000000000: next_state = done_counting ? 10'b0000000000 : 10'b1000000000; // Count
            10'b0000000000: next_state = ack ? 10'b0000000001 : 10'b0000000000; // Wait
            default: next_state = 10'b0000000001;
        endcase
    end

    // Next state outputs
    assign S_next = next_state[0];
    assign S1_next = next_state[1];
    assign B3_next = next_state[7];
    assign Count_next = next_state[8];
    assign Wait_next = next_state[9];

    // Output logic
    assign done = state[9];
    assign counting = state[8];
    assign shift_ena = |state[7:4];  // B0-B3 states

endmodule