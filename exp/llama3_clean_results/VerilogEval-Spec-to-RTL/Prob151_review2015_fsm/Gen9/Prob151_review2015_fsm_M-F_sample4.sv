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

// Define states
typedef enum logic [1:0] {
    IDLE,
    SHIFT,
    COUNT,
    WAIT_ACK
} state_t;

state_t current_state;
state_t next_state;

reg [3:0] pattern;
reg [2:0] shift_cnt;
reg [3:0] duration;

always @(posedge clk) begin
    if (reset) begin
        current_state <= IDLE;
        shift_ena <= 0;
        counting <= 0;
        done <= 0;
        pattern <= 0;
        shift_cnt <= 0;
        duration <= 0;
    end
    else begin
        case (current_state)
            IDLE: begin
                pattern <= {pattern[2:0], data};
                if (pattern == 4'b1101) begin
                    next_state <= SHIFT;
                    pattern <= 0;
                end
                else begin
                    next_state <= IDLE;
                end
            end
            SHIFT: begin
                shift_ena <= 1;
                if (shift_cnt < 4) begin
                    shift_cnt <= shift_cnt + 1;
                    duration <= {duration[2:0], data};
                    next_state <= SHIFT;
                end
                else begin
                    shift_ena <= 0;
                    shift_cnt <= 0;
                    next_state <= COUNT;
                end
            end
            COUNT: begin
                counting <= 1;
                if (done_counting) begin
                    counting <= 0;
                    next_state <= WAIT_ACK;
                end
                else begin
                    next_state <= COUNT;
                end
            end
            WAIT_ACK: begin
                done <= 1;
                if (ack) begin
                    done <= 0;
                    next_state <= IDLE;
                end
                else begin
                    next_state <= WAIT_ACK;
                end
            end
            default: next_state <= IDLE;
        endcase
        current_state <= next_state;
    end
end

endmodule