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

    // Next state logic using casez for one-hot decoding
    always @(*) begin
        casez (state)
            10'b0000000001: begin // S
                S_next = ~d;
                S1_next = d;
                B3_next = 0;
                Count_next = 0;
                Wait_next = 0;
            end
            10'b0000000010: begin // S1
                S_next = ~d;
                S1_next = 0;
                B3_next = 0;
                Count_next = 0;
                Wait_next = 0;
            end
            10'b0000000100: begin // S11
                S_next = 0;
                S1_next = 0;
                B3_next = 0;
                Count_next = 0;
                Wait_next = 0;
            end
            10'b0000001000: begin // S110
                S_next = ~d;
                S1_next = 0;
                B3_next = d;
                Count_next = 0;
                Wait_next = 0;
            end
            10'b0000010000: begin // B0
                S_next = 0;
                S1_next = 0;
                B3_next = 0;
                Count_next = 0;
                Wait_next = 0;
            end
            10'b0000100000: begin // B1
                S_next = 0;
                S1_next = 0;
                B3_next = 0;
                Count_next = 0;
                Wait_next = 0;
            end
            10'b0001000000: begin // B2
                S_next = 0;
                S1_next = 0;
                B3_next = 1;
                Count_next = 0;
                Wait_next = 0;
            end
            10'b0010000000: begin // B3
                S_next = 0;
                S1_next = 0;
                B3_next = 0;
                Count_next = 1;
                Wait_next = 0;
            end
            10'b0100000000: begin // Count
                S_next = 0;
                S1_next = 0;
                B3_next = 0;
                Count_next = ~done_counting;
                Wait_next = done_counting;
            end
            10'b1000000000: begin // Wait
                S_next = ack;
                S1_next = 0;
                B3_next = 0;
                Count_next = 0;
                Wait_next = ~ack;
            end
            default: begin
                S_next = 0;
                S1_next = 0;
                B3_next = 0;
                Count_next = 0;
                Wait_next = 0;
            end
        endcase
    end

    // Output logic
    assign done = state[9];
    assign counting = state[8];
    assign shift_ena = |state[7:4]; // B0-B3 states

endmodule