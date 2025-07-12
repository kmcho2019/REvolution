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

    // Next state vector (one-hot encoded)
    reg [9:0] next_state;

    // State transition logic
    always @(*) begin
        case (1'b1)  // Synthesis will optimize this to parallel case
            state[0]: next_state = d ? 10'b0000000010 : 10'b0000000001;  // S -> S1 or S
            state[1]: next_state = d ? 10'b0000000100 : 10'b0000000001;  // S1 -> S11 or S
            state[2]: next_state = d ? 10'b0000000100 : 10'b0000001000;  // S11 -> S11 or S110
            state[3]: next_state = d ? 10'b0000010000 : 10'b0000000001;  // S110 -> B0 or S
            state[4]: next_state = 10'b0000100000;  // B0 -> B1
            state[5]: next_state = 10'b0001000000;  // B1 -> B2
            state[6]: next_state = 10'b0010000000;  // B2 -> B3
            state[7]: next_state = 10'b0100000000;  // B3 -> Count
            state[8]: next_state = done_counting ? 10'b1000000000 : 10'b0100000000;  // Count -> Wait or Count
            state[9]: next_state = ack ? 10'b0000000001 : 10'b1000000000;  // Wait -> S or Wait
            default: next_state = 10'b0000000001;  // Default to S
        endcase
    end

    // Next state signals (extracted from next_state vector)
    assign S_next = next_state[0];
    assign S1_next = next_state[1];
    assign B3_next = next_state[7];
    assign Count_next = next_state[8];
    assign Wait_next = next_state[9];

    // Output logic
    assign shift_ena = |state[7:4];  // B0-B3 states
    assign counting = state[8];      // Count state
    assign done = state[9];          // Wait state

endmodule