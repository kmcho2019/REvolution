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

// Define state machine states
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

// Define output signals
reg B3_next_reg;
reg S_next_reg;
reg S1_next_reg;
reg Count_next_reg;
reg Wait_next_reg;
reg done_reg;
reg counting_reg;
reg shift_ena_reg;

// State machine logic
always @(*) begin
    case (state)
        S: begin
            if (!d) begin
                B3_next_reg = 0;
                S_next_reg = 1;
                S1_next_reg = 0;
                Count_next_reg = 0;
                Wait_next_reg = 0;
            end
            else begin
                B3_next_reg = 0;
                S_next_reg = 0;
                S1_next_reg = 1;
                Count_next_reg = 0;
                Wait_next_reg = 0;
            end
        end
        S1: begin
            if (!d) begin
                B3_next_reg = 0;
                S_next_reg = 1;
                S1_next_reg = 0;
                Count_next_reg = 0;
                Wait_next_reg = 0;
            end
            else begin
                B3_next_reg = 0;
                S_next_reg = 0;
                S1_next_reg = 0;
                Count_next_reg = 0;
                Wait_next_reg = 0;
            end
        end
        S11: begin
            if (!d) begin
                B3_next_reg = 0;
                S_next_reg = 0;
                S1_next_reg = 0;
                Count_next_reg = 0;
                Wait_next_reg = 0;
            end
            else begin
                B3_next_reg = 0;
                S_next_reg = 0;
                S1_next_reg = 0;
                Count_next_reg = 0;
                Wait_next_reg = 0;
            end
        end
        S110: begin
            if (!d) begin
                B3_next_reg = 0;
                S_next_reg = 1;
                S1_next_reg = 0;
                Count_next_reg = 0;
                Wait_next_reg = 0;
            end
            else begin
                B3_next_reg = 0;
                S_next_reg = 0;
                S1_next_reg = 0;
                Count_next_reg = 0;
                Wait_next_reg = 0;
            end
        end
        B0: begin
            B3_next_reg = 1;
            S_next_reg = 0;
            S1_next_reg = 0;
            Count_next_reg = 0;
            Wait_next_reg = 0;
        end
        B1: begin
            B3_next_reg = 0;
            S_next_reg = 0;
            S1_next_reg = 0;
            Count_next_reg = 0;
            Wait_next_reg = 0;
        end
        B2: begin
            B3_next_reg = 1;
            S_next_reg = 0;
            S1_next_reg = 0;
            Count_next_reg = 0;
            Wait_next_reg = 0;
        end
        B3: begin
            B3_next_reg = 0;
            S_next_reg = 0;
            S1_next_reg = 0;
            Count_next_reg = 1;
            Wait_next_reg = 0;
        end
        Count: begin
            if (!done_counting) begin
                B3_next_reg = 0;
                S_next_reg = 0;
                S1_next_reg = 0;
                Count_next_reg = 1;
                Wait_next_reg = 0;
            end
            else begin
                B3_next_reg = 0;
                S_next_reg = 0;
                S1_next_reg = 0;
                Count_next_reg = 0;
                Wait_next_reg = 1;
            end
        end
        Wait: begin
            if (ack) begin
                B3_next_reg = 0;
                S_next_reg = 1;
                S1_next_reg = 0;
                Count_next_reg = 0;
                Wait_next_reg = 0;
            end
            else begin
                B3_next_reg = 0;
                S_next_reg = 0;
                S1_next_reg = 0;
                Count_next_reg = 0;
                Wait_next_reg = 1;
            end
        end
        default: begin
            B3_next_reg = 0;
            S_next_reg = 0;
            S1_next_reg = 0;
            Count_next_reg = 0;
            Wait_next_reg = 0;
        end
    endcase

    // Output logic
    shift_ena_reg = (state == B0) || (state == B1) || (state == B2) || (state == B3);
    counting_reg = (state == Count);
    done_reg = (state == Wait);
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