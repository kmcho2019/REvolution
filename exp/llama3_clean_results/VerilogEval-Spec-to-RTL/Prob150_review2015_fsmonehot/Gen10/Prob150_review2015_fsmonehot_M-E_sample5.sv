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

    // Current state
    wire S     = state[0];
    wire S1    = state[1];
    wire S11   = state[2];
    wire S110  = state[3];
    wire B0    = state[4];
    wire B1    = state[5];
    wire B2    = state[6];
    wire B3    = state[7];
    wire Count = state[8];
    wire Wait  = state[9];

    // Next-state logic and output logic using a lookup table (LUT)
    reg B3_next_reg, S_next_reg, S1_next_reg, Count_next_reg, Wait_next_reg;
    reg done_reg, counting_reg, shift_ena_reg;

    always @(*) begin
        case ({S, S1, S11, S110, B0, B1, B2, B3, Count, Wait, d, done_counting, ack})
            // S state
            10'b0000000001_0_0_0: begin
                B3_next_reg = 0;
                S_next_reg = 1;
                S1_next_reg = 0;
                Count_next_reg = 0;
                Wait_next_reg = 0;
                done_reg = 0;
                counting_reg = 0;
                shift_ena_reg = 0;
            end
            10'b0000000001_0_0_1: begin
                B3_next_reg = 0;
                S_next_reg = 0;
                S1_next_reg = 1;
                Count_next_reg = 0;
                Wait_next_reg = 0;
                done_reg = 0;
                counting_reg = 0;
                shift_ena_reg = 0;
            end

            // S1 state
            10'b0000000010_0_0_0: begin
                B3_next_reg = 0;
                S_next_reg = 1;
                S1_next_reg = 0;
                Count_next_reg = 0;
                Wait_next_reg = 0;
                done_reg = 0;
                counting_reg = 0;
                shift_ena_reg = 0;
            end
            10'b0000000010_0_0_1: begin
                B3_next_reg = 0;
                S_next_reg = 0;
                S1_next_reg = 0;
                Count_next_reg = 0;
                Wait_next_reg = 0;
                done_reg = 0;
                counting_reg = 0;
                shift_ena_reg = 0;
            end

            // S11 state
            10'b0000000100_0_0_0: begin
                B3_next_reg = 0;
                S_next_reg = 0;
                S1_next_reg = 0;
                Count_next_reg = 0;
                Wait_next_reg = 0;
                done_reg = 0;
                counting_reg = 0;
                shift_ena_reg = 0;
            end
            10'b0000000100_0_0_1: begin
                B3_next_reg = 0;
                S_next_reg = 0;
                S1_next_reg = 0;
                Count_next_reg = 0;
                Wait_next_reg = 0;
                done_reg = 0;
                counting_reg = 0;
                shift_ena_reg = 0;
            end

            // S110 state
            10'b0000001000_0_0_0: begin
                B3_next_reg = 0;
                S_next_reg = 1;
                S1_next_reg = 0;
                Count_next_reg = 0;
                Wait_next_reg = 0;
                done_reg = 0;
                counting_reg = 0;
                shift_ena_reg = 0;
            end
            10'b0000001000_0_0_1: begin
                B3_next_reg = 0;
                S_next_reg = 0;
                S1_next_reg = 0;
                Count_next_reg = 0;
                Wait_next_reg = 0;
                done_reg = 0;
                counting_reg = 0;
                shift_ena_reg = 0;
            end

            // B0 state
            10'b0000010000_0_0_0: begin
                B3_next_reg = 0;
                S_next_reg = 0;
                S1_next_reg = 0;
                Count_next_reg = 0;
                Wait_next_reg = 0;
                done_reg = 0;
                counting_reg = 0;
                shift_ena_reg = 1;
            end
            10'b0000010000_0_0_1: begin
                B3_next_reg = 0;
                S_next_reg = 0;
                S1_next_reg = 0;
                Count_next_reg = 0;
                Wait_next_reg = 0;
                done_reg = 0;
                counting_reg = 0;
                shift_ena_reg = 1;
            end

            // B1 state
            10'b0000100000_0_0_0: begin
                B3_next_reg = 0;
                S_next_reg = 0;
                S1_next_reg = 0;
                Count_next_reg = 0;
                Wait_next_reg = 0;
                done_reg = 0;
                counting_reg = 0;
                shift_ena_reg = 1;
            end
            10'b0000100000_0_0_1: begin
                B3_next_reg = 0;
                S_next_reg = 0;
                S1_next_reg = 0;
                Count_next_reg = 0;
                Wait_next_reg = 0;
                done_reg = 0;
                counting_reg = 0;
                shift_ena_reg = 1;
            end

            // B2 state
            10'b0001000000_0_0_0: begin
                B3_next_reg = 0;
                S_next_reg = 0;
                S1_next_reg = 0;
                Count_next_reg = 0;
                Wait_next_reg = 0;
                done_reg = 0;
                counting_reg = 0;
                shift_ena_reg = 1;
            end
            10'b0001000000_0_0_1: begin
                B3_next_reg = 0;
                S_next_reg = 0;
                S1_next_reg = 0;
                Count_next_reg = 0;
                Wait_next_reg = 0;
                done_reg = 0;
                counting_reg = 0;
                shift_ena_reg = 1;
            end

            // B3 state
            10'b0010000000_0_0_0: begin
                B3_next_reg = 0;
                S_next_reg = 0;
                S1_next_reg = 0;
                Count_next_reg = 1;
                Wait_next_reg = 0;
                done_reg = 0;
                counting_reg = 0;
                shift_ena_reg = 1;
            end
            10'b0010000000_0_0_1: begin
                B3_next_reg = 0;
                S_next_reg = 0;
                S1_next_reg = 0;
                Count_next_reg = 1;
                Wait_next_reg = 0;
                done_reg = 0;
                counting_reg = 0;
                shift_ena_reg = 1;
            end

            // Count state
            10'b0100000000_0_0_0: begin
                B3_next_reg = 0;
                S_next_reg = 0;
                S1_next_reg = 0;
                Count_next_reg = 1;
                Wait_next_reg = 0;
                done_reg = 0;
                counting_reg = 1;
                shift_ena_reg = 0;
            end
            10'b0100000000_0_0_1: begin
                B3_next_reg = 0;
                S_next_reg = 0;
                S1_next_reg = 0;
                Count_next_reg = 0;
                Wait_next_reg = 1;
                done_reg = 0;
                counting_reg = 1;
                shift_ena_reg = 0;
            end

            // Wait state
            10'b1000000000_0_0_0: begin
                B3_next_reg = 0;
                S_next_reg = 0;
                S1_next_reg = 0;
                Count_next_reg = 0;
                Wait_next_reg = 1;
                done_reg = 1;
                counting_reg = 0;
                shift_ena_reg = 0;
            end
            10'b1000000000_0_0_1: begin
                B3_next_reg = 0;
                S_next_reg = 1;
                S1_next_reg = 0;
                Count_next_reg = 0;
                Wait_next_reg = 0;
                done_reg = 1;
                counting_reg = 0;
                shift_ena_reg = 0;
            end

            default: begin
                B3_next_reg = 0;
                S_next_reg = 0;
                S1_next_reg = 0;
                Count_next_reg = 0;
                Wait_next_reg = 0;
                done_reg = 0;
                counting_reg = 0;
                shift_ena_reg = 0;
            end
        endcase

        B3_next = B3_next_reg;
        S_next = S_next_reg;
        S1_next = S1_next_reg;
        Count_next = Count_next_reg;
        Wait_next = Wait_next_reg;
        done = done_reg;
        counting = counting_reg;
        shift_ena = shift_ena_reg;
    end

endmodule