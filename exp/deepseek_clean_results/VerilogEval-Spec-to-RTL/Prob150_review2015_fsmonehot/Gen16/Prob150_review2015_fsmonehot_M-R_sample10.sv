module TopModule (
    input d,
    input done_counting,
    input ack,
    input [9:0] state,
    output reg B3_next,
    output reg S_next,
    output reg S1_next,
    output reg Count_next,
    output reg Wait_next,
    output reg done,
    output reg counting,
    output reg shift_ena
);

always_comb begin
    // Default assignments
    B3_next = 1'b0;
    S_next = 1'b0;
    S1_next = 1'b0;
    Count_next = 1'b0;
    Wait_next = 1'b0;
    done = 1'b0;
    counting = 1'b0;
    shift_ena = 1'b0;

    // State transition logic
    casez (state)
        10'b0000000001: begin // S
            if (~d) S_next = 1'b1;
            else S1_next = 1'b1;
        end
        10'b0000000010: begin // S1
            if (~d) S_next = 1'b1;
            else S1_next = 1'b1;
        end
        10'b0000000100: begin // S11
            if (~d) S_next = 1'b1;
            else S1_next = 1'b1;
        end
        10'b0000001000: begin // S110
            if (~d) S_next = 1'b1;
            else B3_next = 1'b1;
        end
        10'b0000010000: begin // B0
            B3_next = 1'b1;
            shift_ena = 1'b1;
        end
        10'b0000100000: begin // B1
            B3_next = 1'b1;
            shift_ena = 1'b1;
        end
        10'b0001000000: begin // B2
            B3_next = 1'b1;
            shift_ena = 1'b1;
        end
        10'b0010000000: begin // B3
            Count_next = 1'b1;
            shift_ena = 1'b1;
        end
        10'b0100000000: begin // Count
            counting = 1'b1;
            if (done_counting) Wait_next = 1'b1;
            else Count_next = 1'b1;
        end
        10'b1000000000: begin // Wait
            done = 1'b1;
            if (ack) S_next = 1'b1;
            else Wait_next = 1'b1;
        end
        default: begin
            S_next = 1'b1; // Default to S state
        end
    endcase
end

endmodule