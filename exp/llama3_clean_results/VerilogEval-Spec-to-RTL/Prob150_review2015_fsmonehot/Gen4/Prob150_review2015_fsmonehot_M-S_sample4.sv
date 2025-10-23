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

parameter S = 10'b0000000001;
parameter S1 = 10'b0000000010;
parameter S11 = 10'b0000000100;
parameter S110 = 10'b0000001000;
parameter B0 = 10'b0000010000;
parameter B1 = 10'b0000100000;
parameter B2 = 10'b0001000000;
parameter B3 = 10'b0010000000;
parameter Count = 10'b0100000000;
parameter Wait = 10'b1000000000;

always @(*) begin
    B3_next = 1'b0;
    S_next = 1'b0;
    S1_next = 1'b0;
    Count_next = 1'b0;
    Wait_next = 1'b0;
    done = 1'b0;
    counting = 1'b0;
    shift_ena = 1'b0;

    if (state == S) begin
        if (~d) begin
            S_next = 1'b1;
        end else begin
            S1_next = 1'b1;
        end
    end else if (state == S1) begin
        if (~d) begin
            S_next = 1'b1;
        end else begin
            S1_next = 1'b1;
        end
    end else if (state == S11) begin
        if (~d) begin
            S110_next: begin
                S_next = 1'b1;
            end
        end else begin
            S1_next = 1'b1;
        end
    end else if (state == S110) begin
        if (~d) begin
            S_next = 1'b1;
        end else begin
            B0_next: begin
                B3_next = 1'b0;
                S_next = 1'b0;
                S1_next = 1'b0;
                Count_next = 1'b0;
                Wait_next = 1'b0;
                shift_ena = 1'b0;
                B3_next = 1'b0;
            end
        end
    end else if (state == B0) begin
        B3_next = 1'b0;
        S_next = 1'b0;
        S1_next = 1'b0;
        Count_next = 1'b0;
        Wait_next = 1'b0;
        shift_ena = 1'b1;
        B1_next: begin
            B3_next = 1'b0;
        end
    end else if (state == B1) begin
        B3_next = 1'b0;
        S_next = 1'b0;
        S1_next = 1'b0;
        Count_next = 1'b0;
        Wait_next = 1'b0;
        shift_ena = 1'b1;
        B2_next: begin
            B3_next = 1'b0;
        end
    end else if (state == B2) begin
        B3_next = 1'b1;
        S_next = 1'b0;
        S1_next = 1'b0;
        Count_next = 1'b0;
        Wait_next = 1'b0;
        shift_ena = 1'b1;
    end else if (state == B3) begin
        B3_next = 1'b0;
        S_next = 1'b0;
        S1_next = 1'b0;
        Count_next = 1'b1;
        Wait_next = 1'b0;
        shift_ena = 1'b1;
    end else if (state == Count) begin
        if (done_counting) begin
            B3_next = 1'b0;
            S_next = 1'b0;
            S1_next = 1'b0;
            Count_next = 1'b0;
            Wait_next = 1'b1;
        end else begin
            B3_next = 1'b0;
            S_next = 1'b0;
            S1_next = 1'b0;
            Count_next = 1'b1;
            Wait_next = 1'b0;
        end
        counting = 1'b1;
    end else if (state == Wait) begin
        if (ack) begin
            B3_next = 1'b0;
            S_next = 1'b1;
            S1_next = 1'b0;
            Count_next = 1'b0;
            Wait_next = 1'b0;
        end else begin
            B3_next = 1'b0;
            S_next = 1'b0;
            S1_next = 1'b0;
            Count_next = 1'b0;
            Wait_next = 1'b1;
        end
        done = 1'b1;
    end
end

endmodule