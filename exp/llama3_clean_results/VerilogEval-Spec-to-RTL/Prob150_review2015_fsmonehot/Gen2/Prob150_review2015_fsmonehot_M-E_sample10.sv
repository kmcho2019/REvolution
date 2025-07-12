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

reg B3_next_reg, S_next_reg, S1_next_reg, Count_next_reg, Wait_next_reg;
reg done_reg, counting_reg, shift_ena_reg;

always @(state or d or done_counting or ack) begin
    case (state)
        10'b0000000001: // S
            begin
                if (d == 1'b0) begin
                    B3_next_reg = 1'b0;
                    S_next_reg = 1'b1;
                    S1_next_reg = 1'b0;
                    Count_next_reg = 1'b0;
                    Wait_next_reg = 1'b0;
                end
                else if (d == 1'b1) begin
                    B3_next_reg = 1'b0;
                    S_next_reg = 1'b0;
                    S1_next_reg = 1'b1;
                    Count_next_reg = 1'b0;
                    Wait_next_reg = 1'b0;
                end
            end
        10'b0000000010: // S1
            begin
                if (d == 1'b0) begin
                    B3_next_reg = 1'b0;
                    S_next_reg = 1'b1;
                    S1_next_reg = 1'b0;
                    Count_next_reg = 1'b0;
                    Wait_next_reg = 1'b0;
                end
                else if (d == 1'b1) begin
                    B3_next_reg = 1'b0;
                    S_next_reg = 1'b0;
                    S1_next_reg = 1'b0;
                    Count_next_reg = 1'b0;
                    Wait_next_reg = 1'b0;
                    // transition to S11
                end
            end
        10'b0000000100: // S11
            begin
                if (d == 1'b0) begin
                    B3_next_reg = 1'b0;
                    S_next_reg = 1'b0;
                    S1_next_reg = 1'b0;
                    Count_next_reg = 1'b0;
                    Wait_next_reg = 1'b0;
                    // transition to S110
                end
                else if (d == 1'b1) begin
                    B3_next_reg = 1'b0;
                    S_next_reg = 1'b0;
                    S1_next_reg = 1'b0;
                    Count_next_reg = 1'b0;
                    Wait_next_reg = 1'b0;
                    // stay in S11
                end
            end
        10'b0000001000: // S110
            begin
                if (d == 1'b0) begin
                    B3_next_reg = 1'b0;
                    S_next_reg = 1'b1;
                    S1_next_reg = 1'b0;
                    Count_next_reg = 1'b0;
                    Wait_next_reg = 1'b0;
                end
                else if (d == 1'b1) begin
                    B3_next_reg = 1'b0;
                    S_next_reg = 1'b0;
                    S1_next_reg = 1'b0;
                    Count_next_reg = 1'b0;
                    Wait_next_reg = 1'b0;
                    // transition to B0
                end
            end
        10'b0000010000: // B0
            begin
                B3_next_reg = 1'b0;
                S_next_reg = 1'b0;
                S1_next_reg = 1'b0;
                Count_next_reg = 1'b0;
                Wait_next_reg = 1'b0;
                // transition to B1
            end
        10'b0000100000: // B1
            begin
                B3_next_reg = 1'b0;
                S_next_reg = 1'b0;
                S1_next_reg = 1'b0;
                Count_next_reg = 1'b0;
                Wait_next_reg = 1'b0;
                // transition to B2
            end
        10'b0001000000: // B2
            begin
                B3_next_reg = 1'b1;
                S_next_reg = 1'b0;
                S1_next_reg = 1'b0;
                Count_next_reg = 1'b0;
                Wait_next_reg = 1'b0;
            end
        10'b0010000000: // B3
            begin
                B3_next_reg = 1'b0;
                S_next_reg = 1'b0;
                S1_next_reg = 1'b0;
                Count_next_reg = 1'b1;
                Wait_next_reg = 1'b0;
            end
        10'b0100000000: // Count
            begin
                if (done_counting == 1'b0) begin
                    B3_next_reg = 1'b0;
                    S_next_reg = 1'b0;
                    S1_next_reg = 1'b0;
                    Count_next_reg = 1'b1;
                    Wait_next_reg = 1'b0;
                end
                else if (done_counting == 1'b1) begin
                    B3_next_reg = 1'b0;
                    S_next_reg = 1'b0;
                    S1_next_reg = 1'b0;
                    Count_next_reg = 1'b0;
                    Wait_next_reg = 1'b1;
                end
            end
        10'b1000000000: // Wait
            begin
                if (ack == 1'b0) begin
                    B3_next_reg = 1'b0;
                    S_next_reg = 1'b0;
                    S1_next_reg = 1'b0;
                    Count_next_reg = 1'b0;
                    Wait_next_reg = 1'b1;
                end
                else if (ack == 1'b1) begin
                    B3_next_reg = 1'b0;
                    S_next_reg = 1'b1;
                    S1_next_reg = 1'b0;
                    Count_next_reg = 1'b0;
                    Wait_next_reg = 1'b0;
                end
            end
        default:
            begin
                B3_next_reg = 1'b0;
                S_next_reg = 1'b0;
                S1_next_reg = 1'b0;
                Count_next_reg = 1'b0;
                Wait_next_reg = 1'b0;
            end
    endcase
    
    case (state)
        10'b0000010000: // B0
        10'b0000100000: // B1
        10'b0001000000: // B2
        10'b0010000000: // B3
            shift_ena_reg = 1'b1;
        10'b0100000000: // Count
            counting_reg = 1'b1;
        10'b1000000000: // Wait
            done_reg = 1'b1;
        default:
            begin
                shift_ena_reg = 1'b0;
                counting_reg = 1'b0;
                done_reg = 1'b0;
            end
    endcase
    
    assign B3_next = B3_next_reg;
    assign S_next = S_next_reg;
    assign S1_next = S1_next_reg;
    assign Count_next = Count_next_reg;
    assign Wait_next = Wait_next_reg;
    assign shift_ena = shift_ena_reg;
    assign counting = counting_reg;
    assign done = done_reg;
end

endmodule