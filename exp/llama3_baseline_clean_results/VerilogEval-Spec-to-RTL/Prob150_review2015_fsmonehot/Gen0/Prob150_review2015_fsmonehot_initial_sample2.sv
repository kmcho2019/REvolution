module TopModule(
    input  d,
    input  done_counting,
    input  ack,
    input  [9:0] state,
    output B3_next,
    output S_next,
    output S1_next,
    output Count_next,
    output Wait_next,
    output done,
    output counting,
    output shift_ena
);

reg B3_next_reg;
reg S_next_reg;
reg S1_next_reg;
reg Count_next_reg;
reg Wait_next_reg;
reg done_reg;
reg counting_reg;
reg shift_ena_reg;

always @(*) begin
    // Next state logic
    case (state)
        10'b0000000001: // S
            if (d == 0) begin
                S_next_reg = 1'b1;
                S1_next_reg = 1'b0;
                Count_next_reg = 1'b0;
                Wait_next_reg = 1'b0;
                B3_next_reg = 1'b0;
            end else begin
                S_next_reg = 1'b0;
                S1_next_reg = 1'b1;
                Count_next_reg = 1'b0;
                Wait_next_reg = 1'b0;
                B3_next_reg = 1'b0;
            end
        10'b0000000010: // S1
            if (d == 0) begin
                S_next_reg = 1'b1;
                S1_next_reg = 1'b0;
                Count_next_reg = 1'b0;
                Wait_next_reg = 1'b0;
                B3_next_reg = 1'b0;
            end else begin
                S_next_reg = 1'b0;
                S1_next_reg = 1'b0;
                Count_next_reg = 1'b0;
                Wait_next_reg = 1'b0;
                B3_next_reg = 1'b0;
            end
        10'b0000000100: // S11
            if (d == 0) begin
                S_next_reg = 1'b0;
                S1_next_reg = 1'b0;
                Count_next_reg = 1'b0;
                Wait_next_reg = 1'b0;
                B3_next_reg = 1'b0;
            end else begin
                S_next_reg = 1'b0;
                S1_next_reg = 1'b0;
                Count_next_reg = 1'b0;
                Wait_next_reg = 1'b0;
                B3_next_reg = 1'b0;
            end
        10'b0000001000: // S110
            if (d == 0) begin
                S_next_reg = 1'b1;
                S1_next_reg = 1'b0;
                Count_next_reg = 1'b0;
                Wait_next_reg = 1'b0;
                B3_next_reg = 1'b0;
            end else begin
                S_next_reg = 1'b0;
                S1_next_reg = 1'b0;
                Count_next_reg = 1'b0;
                Wait_next_reg = 1'b0;
                B3_next_reg = 1'b1;
            end
        10'b0000010000: // B0
            S_next_reg = 1'b0;
            S1_next_reg = 1'b0;
            Count_next_reg = 1'b0;
            Wait_next_reg = 1'b0;
            B3_next_reg = 1'b0;
        10'b0000100000: // B1
            S_next_reg = 1'b0;
            S1_next_reg = 1'b0;
            Count_next_reg = 1'b0;
            Wait_next_reg = 1'b0;
            B3_next_reg = 1'b0;
        10'b0001000000: // B2
            S_next_reg = 1'b0;
            S1_next_reg = 1'b0;
            Count_next_reg = 1'b0;
            Wait_next_reg = 1'b0;
            B3_next_reg = 1'b1;
        10'b0010000000: // B3
            S_next_reg = 1'b0;
            S1_next_reg = 1'b0;
            Count_next_reg = 1'b1;
            Wait_next_reg = 1'b0;
            B3_next_reg = 1'b0;
        10'b0100000000: // Count
            if (done_counting == 0) begin
                S_next_reg = 1'b0;
                S1_next_reg = 1'b0;
                Count_next_reg = 1'b1;
                Wait_next_reg = 1'b0;
                B3_next_reg = 1'b0;
            end else begin
                S_next_reg = 1'b0;
                S1_next_reg = 1'b0;
                Count_next_reg = 1'b0;
                Wait_next_reg = 1'b1;
                B3_next_reg = 1'b0;
            end
        10'b1000000000: // Wait
            if (ack == 0) begin
                S_next_reg = 1'b0;
                S1_next_reg = 1'b0;
                Count_next_reg = 1'b0;
                Wait_next_reg = 1'b1;
                B3_next_reg = 1'b0;
            end else begin
                S_next_reg = 1'b1;
                S1_next_reg = 1'b0;
                Count_next_reg = 1'b0;
                Wait_next_reg = 1'b0;
                B3_next_reg = 1'b0;
            end
        default: begin
            S_next_reg = 1'b0;
            S1_next_reg = 1'b0;
            Count_next_reg = 1'b0;
            Wait_next_reg = 1'b0;
            B3_next_reg = 1'b0;
        end
    endcase

    // Output logic
    case (state)
        10'b0000000001: // S
        10'b0000000010: // S1
        10'b0000000100: // S11
        10'b0000001000: // S110
            begin
                done_reg = 1'b0;
                counting_reg = 1'b0;
                shift_ena_reg = 1'b0;
            end
        10'b0000010000: // B0
        10'b0000100000: // B1
        10'b0001000000: // B2
        10'b0010000000: // B3
            begin
                done_reg = 1'b0;
                counting_reg = 1'b0;
                shift_ena_reg = 1'b1;
            end
        10'b0100000000: // Count
            begin
                done_reg = 1'b0;
                counting_reg = 1'b1;
                shift_ena_reg = 1'b0;
            end
        10'b1000000000: // Wait
            begin
                done_reg = 1'b1;
                counting_reg = 1'b0;
                shift_ena_reg = 1'b0;
            end
        default: begin
            done_reg = 1'b0;
            counting_reg = 1'b0;
            shift_ena_reg = 1'b0;
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