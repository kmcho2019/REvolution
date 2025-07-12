module TopModule(
    input  d,
    input  done_counting,
    input  ack,
    input  [9:0] state, // one-hot encoding
    output B3_next,
    output S_next,
    output S1_next,
    output Count_next,
    output Wait_next,
    output done,
    output counting,
    output shift_ena
);

reg B3_next_reg;
reg S_next_reg;
reg S1_next_reg;
reg Count_next_reg;
reg Wait_next_reg;
reg done_reg;
reg counting_reg;
reg shift_ena_reg;

always @(*) begin
    // next-state logic
    case (1'b1)
        state[0]: begin // S
            if (~d) begin
                S_next_reg = 1'b1;
            end else begin
                S1_next_reg = 1'b1;
            end
            B3_next_reg = 1'b0;
            Count_next_reg = 1'b0;
            Wait_next_reg = 1'b0;
        end
        state[1]: begin // S1
            if (~d) begin
                S_next_reg = 1'b1;
            end else begin
                S1_next_reg = 1'b0;
                // goes to S11, but not needed here
            end
            B3_next_reg = 1'b0;
            Count_next_reg = 1'b0;
            Wait_next_reg = 1'b0;
        end
        state[2]: begin // S11
            if (~d) begin
                // goes to S110, but not needed here
            end else begin
                // stays in S11
            end
            B3_next_reg = 1'b0;
            Count_next_reg = 1'b0;
            Wait_next_reg = 1'b0;
        end
        state[3]: begin // S110
            if (~d) begin
                S_next_reg = 1'b1;
            end else begin
                // goes to B0, but not needed here
            end
            B3_next_reg = 1'b0;
            Count_next_reg = 1'b0;
            Wait_next_reg = 1'b0;
        end
        state[4]: begin // B0
            B3_next_reg = 1'b0;
            Count_next_reg = 1'b0;
            Wait_next_reg = 1'b0;
            // goes to B1, but not needed here
        end
        state[5]: begin // B1
            B3_next_reg = 1'b0;
            Count_next_reg = 1'b0;
            Wait_next_reg = 1'b0;
            // goes to B2, but not needed here
        end
        state[6]: begin // B2
            B3_next_reg = 1'b1;
            Count_next_reg = 1'b0;
            Wait_next_reg = 1'b0;
            // goes to B3, but not needed here
        end
        state[7]: begin // B3
            B3_next_reg = 1'b0;
            Count_next_reg = 1'b1;
            Wait_next_reg = 1'b0;
            // goes to Count, but not needed here
        end
        state[8]: begin // Count
            B3_next_reg = 1'b0;
            if (~done_counting) begin
                Count_next_reg = 1'b1;
            end else begin
                Count_next_reg = 1'b0;
                Wait_next_reg = 1'b1;
            end
        end
        state[9]: begin // Wait
            B3_next_reg = 1'b0;
            Count_next_reg = 1'b0;
            if (~ack) begin
                Wait_next_reg = 1'b1;
            end else begin
                Wait_next_reg = 1'b0;
                S_next_reg = 1'b1;
            end
        end
    endcase
    
    // output logic
    shift_ena_reg = state[4] | state[5] | state[6] | state[7];
    counting_reg = state[8];
    done_reg = state[9];
    
    // default values
    S_next_reg = 1'b0;
    S1_next_reg = 1'b0;
    B3_next_reg = 1'b0;
    Count_next_reg = 1'b0;
    Wait_next_reg = 1'b0;
    shift_ena_reg = 1'b0;
    counting_reg = 1'b0;
    done_reg = 1'b0;
end

assign B3_next = B3_next_reg;
assign S_next = S_next_reg;
assign S1_next = S1_next_reg;
assign Count_next = Count_next_reg;
assign Wait_next = Wait_next_reg;
assign done = done_reg;
assign counting = counting_reg;
assign shift_ena = shift_ena_reg;

endmodule