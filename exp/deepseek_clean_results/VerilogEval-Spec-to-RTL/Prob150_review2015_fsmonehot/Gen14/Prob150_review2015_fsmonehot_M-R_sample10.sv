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

    // Next state logic using always_comb for clarity
    always_comb begin
        // Default all next states to 0
        {S_next, S1_next, B3_next, Count_next, Wait_next} = 5'b0;

        case (1'b1) // Synthesis will optimize this to parallel case
            state[0]: begin // S state
                if (~d) S_next = 1'b1;
                else S1_next = 1'b1;
            end
            state[1]: begin // S1 state
                if (~d) S_next = 1'b1;
                else S1_next = 1'b1; // Actually goes to S11, but we don't have that output
            end
            state[3]: begin // S110 state
                if (~d) S_next = 1'b1;
                else B3_next = 1'b0; // Actually goes to B0, but we don't have that output
            end
            state[6]: B3_next = 1'b1; // B2 -> B3
            state[7]: Count_next = 1'b1; // B3 -> Count
            state[8]: begin // Count state
                if (done_counting) Wait_next = 1'b1;
                else Count_next = 1'b1;
            end
            state[9]: begin // Wait state
                if (ack) S_next = 1'b1;
                else Wait_next = 1'b1;
            end
            default: ; // Other states handled by default 0 assignment
        endcase
    end

    // Output logic remains combinatorial
    assign done = state[9];
    assign counting = state[8];
    assign shift_ena = |state[7:4]; // B0-B3 states (bits 4-7)

endmodule