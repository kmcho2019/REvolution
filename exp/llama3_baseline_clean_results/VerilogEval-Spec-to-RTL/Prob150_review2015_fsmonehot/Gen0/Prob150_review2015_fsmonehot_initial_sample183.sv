module TopModule(
    input  d,
    input  done_counting,
    input  ack,
    input  [9:0] state,  // One-hot encoding
    output B3_next,
    output S_next,
    output S1_next,
    output Count_next,
    output Wait_next,
    output done,
    output counting,
    output shift_ena
);

    // Output logic
    assign shift_ena = (state[5] || state[4] || state[3] || state[2]);
    assign counting = state[8];
    assign done = state[9];

    // Next-state logic
    always @(*) begin
        B3_next = 0;
        S_next = 0;
        S1_next = 0;
        Count_next = 0;
        Wait_next = 0;

        case (1'b1)
            state[0]: begin  // S state
                if (!d) B3_next = 0;
                else S1_next = 1;
            end
            state[1]: begin  // S1 state
                if (!d) S_next = 1;
                else S1_next = 0;
            end
            state[2]: begin  // S11 state
                if (!d) S1_next = 1;
                else S1_next = 0;
            end
            state[3]: begin  // S110 state
                if (!d) S_next = 1;
                else B3_next = 1;
            end
            state[4]: begin  // B0 state
                B3_next = 0;
            end
            state[5]: begin  // B1 state
                B3_next = 0;
            end
            state[6]: begin  // B2 state
                B3_next = 0;
            end
            state[7]: begin  // B3 state
                Count_next = 1;
            end
            state[8]: begin  // Count state
                if (!done_counting) Count_next = 1;
                else Wait_next = 1;
            end
            state[9]: begin  // Wait state
                if (ack) S_next = 1;
                else Wait_next = 1;
            end
        endcase
    end

endmodule