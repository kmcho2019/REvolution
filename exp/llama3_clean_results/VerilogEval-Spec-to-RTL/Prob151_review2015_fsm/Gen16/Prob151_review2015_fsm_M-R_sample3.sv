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
    DONE_ACK
} state, next_state;

reg [3:0] pattern;
reg [1:0] shift_cnt;

always @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        pattern <= 0;
        shift_cnt <= 0;
        shift_ena <= 0;
        counting <= 0;
        done <= 0;
    end
    else begin
        state <= next_state;
        case (state)
            IDLE: begin
                pattern <= {pattern[2:0], data};
                if (pattern == 4'b1101) begin
                    next_state <= SHIFT;
                    shift_cnt <= 0;
                    shift_ena <= 1;
                end
                else begin
                    shift_ena <= 0;
                end
            end
            SHIFT: begin
                shift_cnt <= shift_cnt + 1;
                shift_ena <= (shift_cnt < 4);
                if (shift_cnt == 4) begin
                    next_state <= COUNT;
                end
            end
            COUNT: begin
                counting <= 1;
                if (done_counting) begin
                    next_state <= DONE_ACK;
                    counting <= 0;
                    done <= 1;
                end
            end
            DONE_ACK: begin
                done <= 1;
                if (ack) begin
                    next_state <= IDLE;
                    done <= 0;
                end
            end
        endcase
    end
end

endmodule