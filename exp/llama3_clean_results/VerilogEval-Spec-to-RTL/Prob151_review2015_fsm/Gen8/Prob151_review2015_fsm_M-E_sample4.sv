module TopModule (
    input clk,
    input reset,
    input data,
    input done_counting,
    input ack,
    output reg shift_ena,
    output reg counting,
    output reg done
);

reg [1:0] state;
reg [2:0] shift_cnt;
reg [3:0] pattern;
reg pattern_detected;

parameter IDLE = 2'b00;
parameter SHIFT = 2'b01;
parameter COUNT = 2'b10;
parameter WAIT_ACK = 2'b11;

parameter IDLE_WAIT = 2'b00;
parameter IDLE_PATTERN_DETECT = 2'b01;

parameter SHIFT_ENABLE = 2'b00;
parameter SHIFT_DISABLE = 2'b01;

parameter COUNT_ENABLE = 2'b00;
parameter COUNT_DISABLE = 2'b01;

parameter WAIT_ACK_ENABLE = 2'b00;
parameter WAIT_ACK_DISABLE = 2'b01;

reg [1:0] idle_state;
reg [1:0] shift_state;
reg [1:0] count_state;
reg [1:0] wait_ack_state;

always @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        shift_cnt <= 0;
        pattern <= 0;
        pattern_detected <= 0;
        shift_ena <= 0;
        counting <= 0;
        done <= 0;
        idle_state <= IDLE_WAIT;
        shift_state <= SHIFT_ENABLE;
        count_state <= COUNT_ENABLE;
        wait_ack_state <= WAIT_ACK_ENABLE;
    end
    else begin
        case (state)
            IDLE: begin
                case (idle_state)
                    IDLE_WAIT: begin
                        pattern <= {pattern[2:0], data};
                        if (pattern == 4'b1101) begin
                            pattern_detected <= 1;
                            idle_state <= IDLE_PATTERN_DETECT;
                        end
                    end
                    IDLE_PATTERN_DETECT: begin
                        if (pattern_detected) begin
                            state <= SHIFT;
                            idle_state <= IDLE_WAIT;
                            pattern_detected <= 0;
                        end
                    end
                endcase
            end
            SHIFT: begin
                case (shift_state)
                    SHIFT_ENABLE: begin
                        shift_ena <= 1;
                        shift_cnt <= shift_cnt + 1;
                        if (shift_cnt == 4) begin
                            shift_state <= SHIFT_DISABLE;
                        end
                    end
                    SHIFT_DISABLE: begin
                        shift_ena <= 0;
                        state <= COUNT;
                        shift_state <= SHIFT_ENABLE;
                        shift_cnt <= 0;
                    end
                endcase
            end
            COUNT: begin
                case (count_state)
                    COUNT_ENABLE: begin
                        counting <= 1;
                        if (done_counting) begin
                            count_state <= COUNT_DISABLE;
                        end
                    end
                    COUNT_DISABLE: begin
                        counting <= 0;
                        state <= WAIT_ACK;
                        count_state <= COUNT_ENABLE;
                    end
                endcase
            end
            WAIT_ACK: begin
                case (wait_ack_state)
                    WAIT_ACK_ENABLE: begin
                        done <= 1;
                        if (ack) begin
                            wait_ack_state <= WAIT_ACK_DISABLE;
                        end
                    end
                    WAIT_ACK_DISABLE: begin
                        done <= 0;
                        state <= IDLE;
                        wait_ack_state <= WAIT_ACK_ENABLE;
                    end
                endcase
            end
        endcase
    end
end

endmodule