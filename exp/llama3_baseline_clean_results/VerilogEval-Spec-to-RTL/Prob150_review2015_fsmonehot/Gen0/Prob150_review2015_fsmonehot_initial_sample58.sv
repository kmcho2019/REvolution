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

    // Next-state logic
    always_comb begin
        B3_next = 0;
        S_next = 0;
        S1_next = 0;
        Count_next = 0;
        Wait_next = 0;

        if (state == 10'b0000000001) begin // S
            if (!d) begin
                S_next = 1;
            end else begin
                S1_next = 1;
            end
        end else if (state == 10'b0000000010) begin // S1
            if (!d) begin
                S_next = 1;
            end else begin
                S1_next = 1; // Changed to S11_next = 1;
            end
        end else if (state == 10'b0000000100) begin // S11
            if (!d) begin
                S_next = 0; // Changed to S110_next = 1;
            end else begin
                S1_next = 1;
            end
        end else if (state == 10'b0000001000) begin // S110
            if (!d) begin
                S_next = 1;
            end else begin
                B3_next = 0; // Changed to B0_next = 1;
            end
        end else if (state == 10'b0000010000) begin // B0
            B3_next = 0; // Changed to B1_next = 1;
        end else if (state == 10'b0000100000) begin // B1
            B3_next = 0; // Changed to B2_next = 1;
        end else if (state == 10'b0001000000) begin // B2
            B3_next = 1; // Changed to B3_next = 1;
        end else if (state == 10'b0010000000) begin // B3
            Count_next = 1;
        end else if (state == 10'b0100000000) begin // Count
            if (!done_counting) begin
                Count_next = 1;
            end else begin
                Wait_next = 1;
            end
        end else if (state == 10'b1000000000) begin // Wait
            if (!ack) begin
                Wait_next = 1;
            end else begin
                S_next = 1;
            end
        end
    end

    // Output logic
    always_comb begin
        shift_ena = (state == 10'b0000010000) || (state == 10'b0000100000) || (state == 10'b0001000000) || (state == 10'b0010000000);
        counting = (state == 10'b0100000000);
        done = (state == 10'b1000000000);
    end

endmodule