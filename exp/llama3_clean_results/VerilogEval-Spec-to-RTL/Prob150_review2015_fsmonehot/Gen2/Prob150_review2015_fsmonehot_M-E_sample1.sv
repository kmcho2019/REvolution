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

reg B3_next_reg;
reg S_next_reg;
reg S1_next_reg;
reg Count_next_reg;
reg Wait_next_reg;
reg done_reg;
reg counting_reg;
reg shift_ena_reg;

always @(*) begin
    B3_next_reg = 1'b0;
    S_next_reg = 1'b0;
    S1_next_reg = 1'b0;
    Count_next_reg = 1'b0;
    Wait_next_reg = 1'b0;
    done_reg = 1'b0;
    counting_reg = 1'b0;
    shift_ena_reg = 1'b0;

    case (1'b1)
        state[0]: begin  // S state
            if (~d) begin
                S_next_reg = 1'b1;
            end else begin
                S1_next_reg = 1'b1;
            end
        end
        state[1]: begin  // S1 state
            if (~d) begin
                S_next_reg = 1'b1;
            end else begin
                S1_next_reg = 1'b1;
            end
        end
        state[2]: begin  // S11 state
            if (~d) begin
                S110_next_reg = 1'b1;
            end else begin
                S1_next_reg = 1'b1;
            end
        end
        state[3]: begin  // S110 state
            if (~d) begin
                S_next_reg = 1'b1;
            end else begin
                B0_next_reg = 1'b1;
            end
        end
        state[4]: begin  // B0 state
            B1_next_reg = 1'b1;
            shift_ena_reg = 1'b1;
        end
        state[5]: begin  // B1 state
            B2_next_reg = 1'b1;
            shift_ena_reg = 1'b1;
        end
        state[6]: begin  // B2 state
            B3_next_reg = 1'b1;
            shift_ena_reg = 1'b1;
        end
        state[7]: begin  // B3 state
            Count_next_reg = 1'b1;
            shift_ena_reg = 1'b1;
        end
        state[8]: begin  // Count state
            if (done_counting) begin
                Wait_next_reg = 1'b1;
            end else begin
                Count_next_reg = 1'b1;
            end
            counting_reg = 1'b1;
        end
        state[9]: begin  // Wait state
            if (ack) begin
                S_next_reg = 1'b1;
            end else begin
                Wait_next_reg = 1'b1;
            end
            done_reg = 1'b1;
        end
    endcase
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