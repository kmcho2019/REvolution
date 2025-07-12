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

reg [3:0] pattern_reg;
reg [1:0] state_reg;
reg [2:0] shift_cnt;
reg shift_ena_reg;
reg counting_reg;
reg done_reg;

parameter IDLE = 2'b00;
parameter SHIFT = 2'b01;
parameter COUNT = 2'b10;
parameter DONE_ACK = 2'b11;

always @(posedge clk) begin
    if (reset) begin
        state_reg <= IDLE;
        pattern_reg <= 4'b0000;
        shift_cnt <= 3'b000;
        shift_ena_reg <= 1'b0;
        counting_reg <= 1'b0;
        done_reg <= 1'b0;
    end else begin
        case (state_reg)
            IDLE: begin
                if (pattern_reg == 4'b1101) begin
                    state_reg <= SHIFT;
                    pattern_reg <= 4'b0000;
                    shift_cnt <= 3'b000;
                    shift_ena_reg <= 1'b1;
                    counting_reg <= 1'b0;
                    done_reg <= 1'b0;
                end else begin
                    pattern_reg <= {pattern_reg[2:0], data};
                end
            end
            SHIFT: begin
                shift_cnt <= shift_cnt + 1'b1;
                if (shift_cnt == 3'b100) begin
                    state_reg <= COUNT;
                    shift_ena_reg <= 1'b0;
                    counting_reg <= 1'b1;
                end
            end
            COUNT: begin
                if (done_counting) begin
                    state_reg <= DONE_ACK;
                    counting_reg <= 1'b0;
                    done_reg <= 1'b1;
                end
            end
            DONE_ACK: begin
                if (ack) begin
                    state_reg <= IDLE;
                    done_reg <= 1'b0;
                end
            end
            default: begin
                state_reg <= IDLE;
                pattern_reg <= 4'b0000;
                shift_cnt <= 3'b000;
                shift_ena_reg <= 1'b0;
                counting_reg <= 1'b0;
                done_reg <= 1'b0;
            end
        endcase
    end
end

assign shift_ena = shift_ena_reg;
assign counting = counting_reg;
assign done = done_reg;

endmodule