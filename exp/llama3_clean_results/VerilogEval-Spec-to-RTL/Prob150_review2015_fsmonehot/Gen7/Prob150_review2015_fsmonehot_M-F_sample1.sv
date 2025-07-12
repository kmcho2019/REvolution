module TopModule(
    input  d,
    input  done_counting,
    input  ack,
    input  [9:0] state,
    output reg B3_next,
    output reg S_next,
    output reg S1_next,
    output reg Count_next,
    output reg Wait_next,
    output reg done,
    output reg counting,
    output reg shift_ena
);

always @(*) begin
    // Determine next-state signals
    case (state)
        10'b0000000001: // S
            if (d == 1'b0) begin
                S_next = 1'b1;
                S1_next = 1'b0;
                Count_next = 1'b0;
                Wait_next = 1'b0;
                B3_next = 1'b0;
            end else begin
                S_next = 1'b0;
                S1_next = 1'b1;
                Count_next = 1'b0;
                Wait_next = 1'b0;
                B3_next = 1'b0;
            end
        10'b0000000010: // S1
            if (d == 1'b0) begin
                S_next = 1'b1;
                S1_next = 1'b0;
                Count_next = 1'b0;
                Wait_next = 1'b0;
                B3_next = 1'b0;
            end else begin
                S_next = 1'b0;
                S1_next = 1'b0;
                Count_next = 1'b0;
                Wait_next = 1'b0;
                B3_next = 1'b0;
            end
        10'b0000000100: // S11
            if (d == 1'b0) begin
                S_next = 1'b0;
                S1_next = 1'b0;
                Count_next = 1'b0;
                Wait_next = 1'b0;
                B3_next = 1'b0;
            end else begin
                S_next = 1'b0;
                S1_next = 1'b0;
                Count_next = 1'b0;
                Wait_next = 1'b0;
                B3_next = 1'b0;
            end
        10'b0000001000: // S110
            if (d == 1'b0) begin
                S_next = 1'b1;
                S1_next = 1'b0;
                Count_next = 1'b0;
                Wait_next = 1'b0;
                B3_next = 1'b0;
            end else begin
                S_next = 1'b0;
                S1_next = 1'b0;
                Count_next = 1'b0;
                Wait_next = 1'b0;
                B3_next = 1'b0;
            end
        10'b0000010000: // B0
            begin
                S_next = 1'b0;
                S1_next = 1'b0;
                Count_next = 1'b0;
                Wait_next = 1'b0;
                B3_next = 1'b0;
            end
        10'b0000100000: // B1
            begin
                S_next = 1'b0;
                S1_next = 1'b0;
                Count_next = 1'b0;
                Wait_next = 1'b0;
                B3_next = 1'b0;
            end
        10'b0001000000: // B2
            begin
                S_next = 1'b0;
                S1_next = 1'b0;
                Count_next = 1'b0;
                Wait_next = 1'b0;
                B3_next = 1'b1;
            end
        10'b0010000000: // B3
            begin
                S_next = 1'b0;
                S1_next = 1'b0;
                Count_next = 1'b1;
                Wait_next = 1'b0;
                B3_next = 1'b0;
            end
        10'b0100000000: // Count
            if (done_counting == 1'b0) begin
                S_next = 1'b0;
                S1_next = 1'b0;
                Count_next = 1'b1;
                Wait_next = 1'b0;
                B3_next = 1'b0;
            end else begin
                S_next = 1'b0;
                S1_next = 1'b0;
                Count_next = 1'b0;
                Wait_next = 1'b1;
                B3_next = 1'b0;
            end
        10'b1000000000: // Wait
            if (ack == 1'b0) begin
                S_next = 1'b0;
                S1_next = 1'b0;
                Count_next = 1'b0;
                Wait_next = 1'b1;
                B3_next = 1'b0;
            end else begin
                S_next = 1'b1;
                S1_next = 1'b0;
                Count_next = 1'b0;
                Wait_next = 1'b0;
                B3_next = 1'b0;
            end
        default: begin
            S_next = 1'b0;
            S1_next = 1'b0;
            Count_next = 1'b0;
            Wait_next = 1'b0;
            B3_next = 1'b0;
        end
    endcase

    // Determine output signals
    case (state)
        10'b0000010000, // B0
        10'b0000100000, // B1
        10'b0001000000, // B2
        10'b0010000000: // B3
            shift_ena = 1'b1;
        default:
            shift_ena = 1'b0;
    endcase

    case (state)
        10'b0100000000: // Count
            counting = 1'b1;
        default:
            counting = 1'b0;
    endcase

    case (state)
        10'b1000000000: // Wait
            done = 1'b1;
        default:
            done = 1'b0;
    endcase
end

endmodule