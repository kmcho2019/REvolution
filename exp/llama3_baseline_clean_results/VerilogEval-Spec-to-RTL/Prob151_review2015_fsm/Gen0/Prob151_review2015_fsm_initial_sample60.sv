module TopModule (
    input  clk,
    input  reset,
    input  data,
    input  done_counting,
    input  ack,
    output shift_ena,
    output counting,
    output done
);

reg [1:0] state; // 4 states: IDLE, SHIFT, COUNT, DONE
reg [3:0] shift_reg; // 4-bit shift register
reg [3:0] shift_cnt; // counter for shift operation

always @(posedge clk) begin
    if (reset) begin // synchronous reset
        state <= 2'b00; // IDLE state
        shift_reg <= 4'b0000;
        shift_cnt <= 4'b0000;
        shift_ena <= 1'b0;
        counting <= 1'b0;
        done <= 1'b0;
    end else begin
        case (state)
            2'b00: begin // IDLE state
                shift_reg <= {data, shift_reg[3:1]};
                if (shift_reg == 4'b1101) begin
                    state <= 2'b01; // transition to SHIFT state
                    shift_ena <= 1'b1;
                    shift_cnt <= 4'b0001;
                end
                counting <= 1'b0;
                done <= 1'b0;
            end
            2'b01: begin // SHIFT state
                if (shift_cnt == 4'b1000) begin
                    state <= 2'b10; // transition to COUNT state
                    shift_ena <= 1'b0;
                end else begin
                    shift_cnt <= shift_cnt + 1'b1;
                end
                counting <= 1'b0;
                done <= 1'b0;
            end
            2'b10: begin // COUNT state
                counting <= 1'b1;
                if (done_counting) begin
                    state <= 2'b11; // transition to DONE state
                end
                done <= 1'b0;
            end
            2'b11: begin // DONE state
                done <= 1'b1;
                if (ack) begin
                    state <= 2'b00; // transition to IDLE state
                end
                counting <= 1'b0;
            end
        endcase
    end
end

endmodule