module TopModule(
    input  d,
    input  done_counting,
    input  ack,
    input  [9:0] state,  // one-hot encoding
    output B3_next,
    output S_next,
    output S1_next,
    output Count_next,
    output Wait_next,
    output done,
    output counting,
    output shift_ena
);

    always_comb begin
        // Next-state logic
        B3_next = 0;
        S_next = 0;
        S1_next = 0;
        Count_next = 0;
        Wait_next = 0;
        
        case (state)
            10'b0000000001: // S
                if (!d) S_next = 1;
                else S1_next = 1;
            10'b0000000010: // S1
                if (!d) S_next = 1;
                else S1_next = 1;
            10'b0000000100: // S11
                if (!d) S1_next = 1;
                else S1_next = 1;
            10'b0000001000: // S110
                if (!d) S_next = 1;
                else B3_next = 0;
            10'b0000010000: // B0
                B3_next = 1;
            10'b0000100000: // B1
                B3_next = 1;
            10'b0001000000: // B2
                B3_next = 1;
            10'b0010000000: // B3
                Count_next = 1;
            10'b0100000000: // Count
                if (!done_counting) Count_next = 1;
                else Count_next = 0;
            10'b1000000000: // Wait
                if (ack) S_next = 1;
                else Wait_next = 1;
            default: ;
        endcase

        // Output logic
        shift_ena = (state[4] || state[5] || state[6] || state[7]);
        counting = state[8];
        done = state[9];
    end

endmodule