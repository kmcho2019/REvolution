module TopModule(
    input  d,
    input  done_counting,
    input  ack,
    input  [9:0] state, // one-hot encoding
    output B3_next,
    output S_next,
    output S1_next,
    output Count_next,
    output Wait_next,
    output done,
    output counting,
    output shift_ena
);

    // Assign next-state signals based on current state and inputs
    always @(*) begin
        B3_next = 0;
        S_next = 0;
        S1_next = 0;
        Count_next = 0;
        Wait_next = 0;

        case (1'b1)
            state[0]: // S
                if (!d) S_next = 1;
                else S1_next = 1;
            state[1]: // S1
                if (!d) S_next = 1;
                else S1_next = 1;
            state[2]: // S11
                if (!d) Count_next = 1;
                else S1_next = 1;
            state[3]: // S110
                if (!d) S_next = 1;
                else B3_next = 1;
            state[4]: // B0
                B3_next = 1;
            state[5]: // B1
                B3_next = 1;
            state[6]: // B2
                B3_next = 1;
            state[7]: // B3
                Count_next = 1;
            state[8]: // Count
                if (!done_counting) Count_next = 1;
                else Wait_next = 1;
            state[9]: // Wait
                if (!ack) Wait_next = 1;
                else S_next = 1;
        endcase
    end

    // Assign output signals based on current state
    always @(*) begin
        done = state[9];
        counting = state[8];
        shift_ena = state[4] | state[5] | state[6] | state[7];
    end
endmodule