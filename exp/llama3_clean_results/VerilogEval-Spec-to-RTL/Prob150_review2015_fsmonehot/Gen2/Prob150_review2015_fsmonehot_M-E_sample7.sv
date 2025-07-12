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

// Next State Logic
always_comb
begin
    B3_next = 1'b0;
    S_next  = 1'b0;
    S1_next = 1'b0;
    Count_next = 1'b0;
    Wait_next = 1'b0;

    if (state[0]) // State S
    begin
        if (d == 1'b1)
            S1_next = 1'b1;
        else
            S_next = 1'b1;
    end
    else if (state[1]) // State S1
    begin
        if (d == 1'b1)
            S1_next = 1'b1;
        else
            S_next = 1'b1;
    end
    else if (state[2]) // State S11
    begin
        if (d == 1'b1)
            S1_next = 1'b1;
        else
            S_next = 1'b1;
    end
    else if (state[3]) // State S110
    begin
        if (d == 1'b1)
            B3_next = 1'b1;
        else
            S_next = 1'b1;
    end
    else if (state[4]) // State B0
    begin
        S1_next = 1'b1;
    end
    else if (state[5]) // State B1
    begin
        S1_next = 1'b1;
    end
    else if (state[6]) // State B2
    begin
        B3_next = 1'b1;
    end
    else if (state[7]) // State B3
    begin
        Count_next = 1'b1;
    end
    else if (state[8]) // State Count
    begin
        if (done_counting == 1'b1)
            Wait_next = 1'b1;
        else
            Count_next = 1'b1;
    end
    else if (state[9]) // State Wait
    begin
        if (ack == 1'b1)
            S_next = 1'b1;
        else
            Wait_next = 1'b1;
    end
end

// Output Logic
always_comb
begin
    shift_ena = 1'b0;
    counting = 1'b0;
    done    = 1'b0;

    if (state[4] || state[5] || state[6] || state[7]) // States B0, B1, B2, B3
    begin
        shift_ena = 1'b1;
    end

    if (state[8]) // State Count
    begin
        counting = 1'b1;
    end

    if (state[9]) // State Wait
    begin
        done = 1'b1;
    end
end

endmodule