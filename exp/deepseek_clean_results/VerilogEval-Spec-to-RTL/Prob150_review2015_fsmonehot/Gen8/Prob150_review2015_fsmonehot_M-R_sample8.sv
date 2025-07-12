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

    // State definitions using one-hot encoding
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

    // Next state logic using case statement
    reg [9:0] next_state;
    always @(*) begin
        case (1'b1) // synthesis parallel_case
            state[0]: next_state = d ? S1 : S;      // S state
            state[1]: next_state = d ? S11 : S;      // S1 state
            state[2]: next_state = d ? S11 : S110;   // S11 state
            state[3]: next_state = d ? B0 : S;       // S110 state
            state[4]: next_state = B1;               // B0 state
            state[5]: next_state = B2;               // B1 state
            state[6]: next_state = B3;               // B2 state
            state[7]: next_state = Count;            // B3 state
            state[8]: next_state = done_counting ? Wait : Count; // Count state
            state[9]: next_state = ack ? S : Wait;   // Wait state
            default: next_state = S;                 // Default to S
        endcase
    end

    // Next state outputs
    assign S_next = next_state[0];
    assign S1_next = next_state[1];
    assign B3_next = next_state[7];
    assign Count_next = next_state[8];
    assign Wait_next = next_state[9];

    // Output logic
    assign shift_ena = state[4] | state[5] | state[6] | state[7];
    assign counting = state[8];
    assign done = state[9];

endmodule