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

    // Named parameters for one-hot states
    localparam S = 0, S1 = 1, S11 = 2, S110 = 3, B0 = 4, B1 = 5, B2 = 6, B3 = 7, Count = 8, Wait = 9;

    // Next state logic using always_comb for clarity
    always_comb begin
        // Default next states
        {B3_next, S_next, S1_next, Count_next, Wait_next} = 5'b0;

        // State transition logic
        case (1'b1) // synthesis parallel_case
            state[S]: begin
                if (~d) S_next = 1'b1;
                else S1_next = 1'b1;
            end
            state[S1]: begin
                if (~d) S_next = 1'b1;
                else S1_next = 1'b1;
            end
            state[S11]: begin
                if (~d) S_next = 1'b1;
                else S1_next = 1'b1;
            end
            state[S110]: begin
                if (~d) S_next = 1'b1;
                else S_next = 1'b1; // Transition to B0 handled by B3_next
            end
            state[B0]: S_next = 1'b1; // Transition to B1 handled by B3_next
            state[B1]: S_next = 1'b1; // Transition to B2 handled by B3_next
            state[B2]: B3_next = 1'b1;
            state[B3]: Count_next = 1'b1;
            state[Count]: begin
                if (done_counting) Wait_next = 1'b1;
                else Count_next = 1'b1;
            end
            state[Wait]: begin
                if (ack) S_next = 1'b1;
                else Wait_next = 1'b1;
            end
        endcase
    end

    // Output logic
    assign done = state[Wait];
    assign counting = state[Count];
    assign shift_ena = |state[B3:B0]; // B0-B3 states

endmodule