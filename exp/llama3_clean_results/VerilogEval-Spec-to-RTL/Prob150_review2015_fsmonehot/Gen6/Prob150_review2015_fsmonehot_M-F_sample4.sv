module TopModule(
    input  d,
    input  done_counting,
    input  ack,
    input  [9:0] state,
    output logic B3_next,
    output logic S_next,
    output logic S1_next,
    output logic Count_next,
    output logic Wait_next,
    output logic done,
    output logic counting,
    output logic shift_ena
);

// Next State and Output Logic
always_comb
begin
    B3_next = 1'b0;
    S_next  = 1'b0;
    S1_next = 1'b0;
    Count_next = 1'b0;
    Wait_next = 1'b0;
    shift_ena = 1'b0;
    counting = 1'b0;
    done    = 1'b0;

    case (state)
        10'b0000000001: // State S
        begin
            if (d == 1'b0)
                S_next = 1'b1;
            else if (d == 1'b1)
                S1_next = 1'b1;
        end
        10'b0000000010: // State S1
        begin
            if (d == 1'b0)
                S_next = 1'b1;
            else if (d == 1'b1)
                S1_next = 1'b0;
                Count_next = 1'b0;
                Wait_next = 1'b0;
                B3_next = 1'b0;
                S_next = 1'b0;
                S1_next = 1'b1;
        end
        10'b0000000100: // State S11
        begin
            if (d == 1'b0)
                S_next = 1'b0;
                S1_next = 1'b0;
                Count_next = 1'b0;
                Wait_next = 1'b0;
                B3_next = 1'b1;
            else if (d == 1'b1)
                S1_next = 1'b0;
                Count_next = 1'b0;
                Wait_next = 1'b0;
                B3_next = 1'b0;
                S_next = 1'b0;
                S1_next = 1'b0;
        end
        10'b0000001000: // State S110
        begin
            if (d == 1'b0)
                S_next = 1'b1;
            else if (d == 1'b1)
                B3_next = 1'b1;
        end
        10'b0000010000: // State B0
        begin
            shift_ena = 1'b1;
            B3_next = 1'b0;
            S1_next = 1'b0;
            Count_next = 1'b0;
            Wait_next = 1'b0;
            S_next = 1'b0;
            S1_next = 1'b0;
            B3_next = 1'b0;
        end
        10'b0000100000: // State B1
        begin
            shift_ena = 1'b1;
            B3_next = 1'b1;
            S1_next = 1'b0;
            Count_next = 1'b0;
            Wait_next = 1'b0;
        end
        10'b0001000000: // State B2
        begin
            shift_ena = 1'b1;
            B3_next = 1'b1;
        end
        10'b0010000000: // State B3
        begin
            shift_ena = 1'b1;
            Count_next = 1'b1;
        end
        10'b0100000000: // State Count
        begin
            counting = 1'b1;
            if (done_counting == 1'b1)
                Wait_next = 1'b1;
            else
                Count_next = 1'b1;
        end
        10'b1000000000: // State Wait
        begin
            done = 1'b1;
            if (ack == 1'b1)
                S_next = 1'b1;
            else
                Wait_next = 1'b1;
        end
        default:
        begin
            B3_next = 1'b0;
            S_next  = 1'b0;
            S1_next = 1'b0;
            Count_next = 1'b0;
            Wait_next = 1'b0;
            shift_ena = 1'b0;
            counting = 1'b0;
            done    = 1'b0;
        end
    endcase
end

endmodule