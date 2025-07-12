module TopModule (
    input  d,
    input  done_counting,
    input  ack,
    input  [9:0] state,  // one-hot encoding
    output B3_next,
    output S_next,
    output S1_next,
    output Count_next,
    output Wait_next,
    output done,
    output counting,
    output shift_ena
);

    reg B3_next, S_next, S1_next, Count_next, Wait_next;
    reg done, counting, shift_ena;

    always @(*) begin
        // Next-state logic equations
        case (1'b1)
            state[0]: begin  // S
                if (~d) begin
                    S_next = 1'b1;
                end else begin
                    S1_next = 1'b1;
                end
            end
            state[1]: begin  // S1
                if (~d) begin
                    S_next = 1'b1;
                end else begin
                    S1_next = 1'b1;
                end
            end
            state[2]: begin  // S11
                if (~d) begin
                    S110 = 1'b1;
                end else begin
                    S1_next = 1'b1;
                end
            end
            state[3]: begin  // S110
                if (~d) begin
                    S_next = 1'b1;
                end else begin
                    B3_next = 1'b1;
                end
            end
            state[4]: begin  // B0
                B3_next = 1'b1;
            end
            state[5]: begin  // B1
                B3_next = 1'b1;
            end
            state[6]: begin  // B2
                B3_next = 1'b1;
            end
            state[7]: begin  // B3
                Count_next = 1'b1;
            end
            state[8]: begin  // Count
                if (~done_counting) begin
                    Count_next = 1'b1;
                end else begin
                    Wait_next = 1'b1;
                end
            end
            state[9]: begin  // Wait
                if (~ack) begin
                    Wait_next = 1'b1;
                end else begin
                    S_next = 1'b1;
                end
            end
        endcase

        // Output logic equations
        done = state[9];  // Wait
        counting = state[8];  // Count
        shift_ena = state[4] || state[5] || state[6] || state[7];  // B0, B1, B2, B3
    end

endmodule