module TopModule (
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

    // Define the next-state and output logic equations using a case statement
    always @(*) begin
        case ({state, d, done_counting, ack})
            // S state
            10'b0000000001_0_0_0: begin
                S_next = 1'b1;
                B3_next = 1'b0;
                S1_next = 1'b0;
                Count_next = 1'b0;
                Wait_next = 1'b0;
                done = 1'b0;
                counting = 1'b0;
                shift_ena = 1'b0;
            end
            10'b0000000001_1_0_0: begin
                S_next = 1'b0;
                B3_next = 1'b0;
                S1_next = 1'b1;
                Count_next = 1'b0;
                Wait_next = 1'b0;
                done = 1'b0;
                counting = 1'b0;
                shift_ena = 1'b0;
            end

            // S1 state
            10'b0000000010_0_0_0: begin
                S_next = 1'b1;
                B3_next = 1'b0;
                S1_next = 1'b0;
                Count_next = 1'b0;
                Wait_next = 1'b0;
                done = 1'b0;
                counting = 1'b0;
                shift_ena = 1'b0;
            end
            10'b0000000010_1_0_0: begin
                S_next = 1'b0;
                B3_next = 1'b0;
                S1_next = 1'b0;
                Count_next = 1'b0;
                Wait_next = 1'b0;
                done = 1'b0;
                counting = 1'b0;
                shift_ena = 1'b0;
            end

            // S11 state
            10'b0000000100_0_0_0: begin
                S_next = 1'b0;
                B3_next = 1'b0;
                S1_next = 1'b0;
                Count_next = 1'b0;
                Wait_next = 1'b0;
                done = 1'b0;
                counting = 1'b0;
                shift_ena = 1'b0;
            end
            10'b0000000100_1_0_0: begin
                S_next = 1'b0;
                B3_next = 1'b0;
                S1_next = 1'b0;
                Count_next = 1'b0;
                Wait_next = 1'b0;
                done = 1'b0;
                counting = 1'b0;
                shift_ena = 1'b0;
            end

            // S110 state
            10'b0000001000_0_0_0: begin
                S_next = 1'b1;
                B3_next = 1'b0;
                S1_next = 1'b0;
                Count_next = 1'b0;
                Wait_next = 1'b0;
                done = 1'b0;
                counting = 1'b0;
                shift_ena = 1'b0;
            end
            10'b0000001000_1_0_0: begin
                S_next = 1'b0;
                B3_next = 1'b1;
                S1_next = 1'b0;
                Count_next = 1'b0;
                Wait_next = 1'b0;
                done = 1'b0;
                counting = 1'b0;
                shift_ena = 1'b1;
            end

            // B0 state
            10'b0000010000_0_0_0: begin
                S_next = 1'b0;
                B3_next = 1'b0;
                S1_next = 1'b0;
                Count_next = 1'b0;
                Wait_next = 1'b0;
                done = 1'b0;
                counting = 1'b0;
                shift_ena = 1'b1;
            end

            // B1 state
            10'b0000100000_0_0_0: begin
                S_next = 1'b0;
                B3_next = 1'b0;
                S1_next = 1'b0;
                Count_next = 1'b0;
                Wait_next = 1'b0;
                done = 1'b0;
                counting = 1'b0;
                shift_ena = 1'b1;
            end

            // B2 state
            10'b0001000000_0_0_0: begin
                S_next = 1'b0;
                B3_next = 1'b1;
                S1_next = 1'b0;
                Count_next = 1'b0;
                Wait_next = 1'b0;
                done = 1'b0;
                counting = 1'b0;
                shift_ena = 1'b1;
            end

            // B3 state
            10'b0010000000_0_0_0: begin
                S_next = 1'b0;
                B3_next = 1'b0;
                S1_next = 1'b0;
                Count_next = 1'b1;
                Wait_next = 1'b0;
                done = 1'b0;
                counting = 1'b0;
                shift_ena = 1'b1;
            end

            // Count state
            10'b0100000000_0_0_0: begin
                S_next = 1'b0;
                B3_next = 1'b0;
                S1_next = 1'b0;
                Count_next = 1'b1;
                Wait_next = 1'b0;
                done = 1'b0;
                counting = 1'b1;
                shift_ena = 1'b0;
            end
            10'b0100000000_1_0_0: begin
                S_next = 1'b0;
                B3_next = 1'b0;
                S1_next = 1'b0;
                Count_next = 1'b0;
                Wait_next = 1'b1;
                done = 1'b0;
                counting = 1'b1;
                shift_ena = 1'b0;
            end

            // Wait state
            10'b1000000000_0_0_0: begin
                S_next = 1'b0;
                B3_next = 1'b0;
                S1_next = 1'b0;
                Count_next = 1'b0;
                Wait_next = 1'b1;
                done = 1'b1;
                counting = 1'b0;
                shift_ena = 1'b0;
            end
            10'b1000000000_0_0_1: begin
                S_next = 1'b1;
                B3_next = 1'b0;
                S1_next = 1'b0;
                Count_next = 1'b0;
                Wait_next = 1'b0;
                done = 1'b1;
                counting = 1'b0;
                shift_ena = 1'b0;
            end

            default: begin
                S_next = 1'b0;
                B3_next = 1'b0;
                S1_next = 1'b0;
                Count_next = 1'b0;
                Wait_next = 1'b0;
                done = 1'b0;
                counting = 1'b0;
                shift_ena = 1'b0;
            end
        endcase
    end

endmodule