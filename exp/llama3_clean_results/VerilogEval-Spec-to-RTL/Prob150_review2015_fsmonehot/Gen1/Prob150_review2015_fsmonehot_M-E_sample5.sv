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

always_comb
begin
    // Initialize output signals
    B3_next = 1'b0;
    S_next  = 1'b0;
    S1_next = 1'b0;
    Count_next = 1'b0;
    Wait_next = 1'b0;
    shift_ena = 1'b0;
    counting = 1'b0;
    done    = 1'b0;

    case (1'b1)
        state[0]:  // State S
            begin
                if (d == 1'b1)
                    S1_next = 1'b1;
                else
                    S_next = 1'b1;
            end
        state[1]:  // State S1
            begin
                if (d == 1'b1)
                    S1_next = 1'b1;
                else
                    S_next = 1'b1;
            end
        state[2]:  // State S11
            begin
                if (d == 1'b1)
                    S1_next = 1'b1;
                else
                    S_next = 1'b1;
            end
        state[3]:  // State S110
            begin
                if (d == 1'b1)
                    B3_next = 1'b1;
                else
                    S_next = 1'b1;
            end
        state[4]:  // State B0
            begin
                shift_ena = 1'b1;
                S1_next = 1'b1;
            end
        state[5]:  // State B1
            begin
                shift_ena = 1'b1;
                S1_next = 1'b1;
            end
        state[6]:  // State B2
            begin
                shift_ena = 1'b1;
                B3_next = 1'b1;
            end
        state[7]:  // State B3
            begin
                shift_ena = 1'b1;
                Count_next = 1'b1;
            end
        state[8]:  // State Count
            begin
                counting = 1'b1;
                if (done_counting == 1'b1)
                    Wait_next = 1'b1;
                else
                    Count_next = 1'b1;
            end
        state[9]:  // State Wait
            begin
                done = 1'b1;
                if (ack == 1'b1)
                    S_next = 1'b1;
                else
                    Wait_next = 1'b1;
            end
    endcase
end

endmodule