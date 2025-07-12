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

always @(*) begin
    // Next-state logic
    B3_next = 0;
    S_next = 0;
    S1_next = 0;
    Count_next = 0;
    Wait_next = 0;
    
    case (state)
        10'b0000000001: // S
            if (!d) begin
                S_next = 1;
            end else begin
                S1_next = 1;
            end
        10'b0000000010: // S1
            if (!d) begin
                S_next = 1;
            end else begin
                S1_next = 1; // Go to S11
            end
        10'b0000000100: // S11
            if (!d) begin
                S1_next = 1; // Go to S110
            end else begin
                S1_next = 1; // Stay in S11
            end
        10'b0000001000: // S110
            if (!d) begin
                S_next = 1;
            end else begin
                B3_next = 0; // Go to B0
            end
        10'b0000010000: // B0
            B3_next = 1; // Go to B1
        10'b0000100000: // B1
            B3_next = 0; // Go to B2
        10'b0001000000: // B2
            B3_next = 0; // Go to B3
        10'b0010000000: // B3
            Count_next = 1;
        10'b0100000000: // Count
            if (!done_counting) begin
                Count_next = 1;
            end else begin
                Wait_next = 1;
            end
        10'b1000000000: // Wait
            if (!ack) begin
                Wait_next = 1;
            end else begin
                S_next = 1;
            end
    endcase
    
    // Output logic
    shift_ena = (state == 10'b0000010000) || (state == 10'b0000100000) || (state == 10'b0001000000) || (state == 10'b0010000000);
    counting = (state == 10'b0100000000);
    done = (state == 10'b1000000000);
end

endmodule