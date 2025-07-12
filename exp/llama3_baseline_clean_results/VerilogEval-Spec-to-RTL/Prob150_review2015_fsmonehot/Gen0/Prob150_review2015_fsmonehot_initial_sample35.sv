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

// State transition logic
always @(*) begin
    B3_next = 0;
    S_next = 0;
    S1_next = 0;
    Count_next = 0;
    Wait_next = 0;

    if (state == 10'b0000000001) begin // State S
        if (!d) begin
            S_next = 1;
        end else begin
            S1_next = 1;
        end
    end else if (state == 10'b0000000010) begin // State S1
        if (!d) begin
            S_next = 1;
        end else begin
            S1_next = 1;
        end
    end else if (state == 10'b0000000100) begin // State S11
        if (!d) begin
            S1_next = 1;
        end else begin
            S1_next = 1;
        end
    end else if (state == 10'b0000001000) begin // State S110
        if (!d) begin
            S_next = 1;
        end else begin
            B3_next = 0; // Since we are implementing only combinational logic, 
                         // we cannot assign B0_next = 1 here. The correct state should be B0.
        end
    end else if (state == 10'b0000010000) begin // State B0
        B3_next = 0; // Next state is B1
    end else if (state == 10'b0000100000) begin // State B1
        B3_next = 0; // Next state is B2
    end else if (state == 10'b0001000000) begin // State B2
        B3_next = 1; // Next state is B3
    end else if (state == 10'b0010000000) begin // State B3
        Count_next = 1; // Next state is Count
    end else if (state == 10'b0100000000) begin // State Count
        if (done_counting) begin
            Wait_next = 1; // Next state is Wait
        end else begin
            Count_next = 1; // Stay in Count state
        end
    end else if (state == 10'b1000000000) begin // State Wait
        if (ack) begin
            S_next = 1; // Next state is S
        end else begin
            Wait_next = 1; // Stay in Wait state
        end
    end
end

// Output logic
always @(*) begin
    done = 0;
    counting = 0;
    shift_ena = 0;

    if (state == 10'b0000010000 || state == 10'b0000100000 || state == 10'b0001000000 || state == 10'b0010000000) begin
        shift_ena = 1; // States B0, B1, B2, B3
    end

    if (state == 10'b0100000000) begin
        counting = 1; // State Count
    end

    if (state == 10'b1000000000) begin
        done = 1; // State Wait
    end
end

endmodule