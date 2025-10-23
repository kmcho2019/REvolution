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

enum logic [1:0] {
    IDLE,
    SHIFT,
    COUNT,
    WAIT_ACK
} state, next_state;

reg [3:0] pattern;
reg [1:0] shift_cnt;
reg [1:0] wait_cnt;

always @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        pattern <= 0;
        shift_cnt <= 0;
        wait_cnt <= 0;
        shift_ena <= 0;
        counting <= 0;
        done <= 0;
    end
    else begin
        case (state)
            IDLE: begin
                pattern <= {pattern[2:0], data};
                if (pattern == 4'b1101) begin
                    state <= SHIFT;
                    shift_cnt <= 1;
                    shift_ena <= 1;
                end
            end
            SHIFT: begin
                if (shift_cnt < 4) begin
                    shift_cnt <= shift_cnt + 1;
                    shift_ena <= 1;
                end
                else begin
                    state <= COUNT;
                    shift_ena <= 0;
                    counting <= 1;
                end
            end
            COUNT: begin
                if (done_counting) begin
                    state <= WAIT_ACK;
                    counting <= 0;
                    done <= 1;
                end
            end
            WAIT_ACK: begin
                if (ack) begin
                    state <= IDLE;
                    done <= 0;
                end
            end
        endcase
    end
end

endmodule