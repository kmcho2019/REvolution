module TopModule (
    input d,
    input done_counting,
    input ack,
    input [9:0] state,  // One-hot encoded state
    output B3_next,
    output S_next,
    output S1_next,
    output Count_next,
    output Wait_next,
    output done,
    output counting,
    output shift_ena
);

    // State definitions using parameters for clarity
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
    always @(*) begin
        // Default values
        S_next = 0;
        S1_next = 0;
        B3_next = 0;
        Count_next = 0;
        Wait_next = 0;

        case (1'b1) // Synthesis will optimize this to parallel case
            state[0]: begin // S state
                if (d) S1_next = 1;
                else S_next = 1;
            end
            state[1]: begin // S1 state
                if (d) S1_next = 0; // Will be set by S11 case
                else S_next = 1;
            end
            state[2]: begin // S11 state
                if (d) S1_next = 1; // Stay in S11
                else S1_next = 0; // Will be set by S110 case
            end
            state[3]: begin // S110 state
                if (d) B3_next = 0; // Will be set by B0 case
                else S_next = 1;
            end
            state[4]: B3_next = 0; // B0 -> B1 (handled by B1 case)
            state[5]: B3_next = 0; // B1 -> B2 (handled by B2 case)
            state[6]: B3_next = 1; // B2 -> B3
            state[7]: Count_next = 1; // B3 -> Count
            state[8]: begin // Count state
                if (done_counting) Wait_next = 1;
                else Count_next = 1;
            end
            state[9]: begin // Wait state
                if (ack) S_next = 1;
                else Wait_next = 1;
            end
        endcase
    end

    // Output logic remains combinational
    assign shift_ena = state[4] | state[5] | state[6] | state[7]; // B0-B3 states
    assign counting = state[8];   // Count state
    assign done = state[9];       // Wait state

endmodule