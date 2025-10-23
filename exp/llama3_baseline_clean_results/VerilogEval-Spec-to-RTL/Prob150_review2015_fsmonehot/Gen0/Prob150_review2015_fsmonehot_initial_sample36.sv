module TopModule(
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

    reg B3_next;
    reg S_next;
    reg S1_next;
    reg Count_next;
    reg Wait_next;
    reg done;
    reg counting;
    reg shift_ena;

    always @(*)
    begin
        // Next-state logic
        case (state)
            10'b0000000001: // S
            begin
                if (~d)
                    S_next = 1'b1;
                else
                    S1_next = 1'b1;
            end
            10'b0000000010: // S1
            begin
                if (~d)
                    S_next = 1'b1;
                else
                    S1_next = 1'b1;
            end
            10'b0000000100: // S11
            begin
                if (~d)
                    S1_next = 1'b1;
                else
                    S1_next = 1'b1;
            end
            10'b0000001000: // S110
            begin
                if (~d)
                    S_next = 1'b1;
                else
                    B3_next = 1'b1;
            end
            10'b0000010000: // B0
            begin
                B3_next = 1'b1;
            end
            10'b0000100000: // B1
            begin
                B3_next = 1'b1;
            end
            10'b0001000000: // B2
            begin
                B3_next = 1'b1;
            end
            10'b0010000000: // B3
            begin
                Count_next = 1'b1;
            end
            10'b0100000000: // Count
            begin
                if (~done_counting)
                    Count_next = 1'b1;
                else
                    Wait_next = 1'b1;
            end
            10'b1000000000: // Wait
            begin
                if (~ack)
                    Wait_next = 1'b1;
                else
                    S_next = 1'b1;
            end
            default: 
            begin
                S_next = 1'b0;
                S1_next = 1'b0;
                Count_next = 1'b0;
                Wait_next = 1'b0;
                B3_next = 1'b0;
            end
        endcase

        // Output logic
        shift_ena = (state == 10'b0000010000) || (state == 10'b0000100000) || (state == 10'b0001000000) || (state == 10'b0010000000);
        counting = (state == 10'b0100000000);
        done = (state == 10'b1000000000);

        // Reset default values
        B3_next = (state == 10'b0010000000) ? 1'b1 : 1'b0;
        S_next = (state == 10'b0000000001) ? 1'b1 : 1'b0;
        S1_next = (state == 10'b0000000010) ? 1'b1 : 1'b0;
        Count_next = (state == 10'b0100000000) ? 1'b1 : 1'b0;
        Wait_next = (state == 10'b1000000000) ? 1'b1 : 1'b0;
    end

endmodule