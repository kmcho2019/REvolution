module TopModule(
    input clk,
    input reset,
    input data,
    input done_counting,
    input ack,
    output reg shift_ena,
    output reg counting,
    output reg done
);

// Internal state declaration
enum {IDLE, DETECT_PATTERN, SHIFT_IN, COUNTING_STATE, NOTIFY, ACK_WAIT} state, next_state;

// Pattern detection logic
reg [3:0] pattern_buf;
reg pattern_detected;

always @(posedge clk) begin
    if (reset) begin
        pattern_buf <= 4'b0;
        pattern_detected <= 1'b0;
    end else begin
        pattern_buf <= {pattern_buf[2:0], data};
        if (pattern_buf == 4'b1101) begin
            pattern_detected <= 1'b1;
        end else begin
            pattern_detected <= 1'b0;
        end
    end
end

// State machine logic
always @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        shift_ena <= 1'b0;
        counting <= 1'b0;
        done <= 1'b0;
    end else begin
        case (state)
            IDLE: begin
                if (pattern_detected) begin
                    state <= DETECT_PATTERN;
                end else begin
                    state <= IDLE;
                end
                shift_ena <= 1'b0;
                counting <= 1'b0;
                done <= 1'b0;
            end
            DETECT_PATTERN: begin
                shift_ena <= 1'b1;
                state <= SHIFT_IN;
            end
            SHIFT_IN: begin
                shift_ena <= 1'b1;
                if (shift_ena && ~shift_ena) begin // After 4 clocks
                    state <= COUNTING_STATE;
                end else begin
                    state <= SHIFT_IN;
                end
            end
            COUNTING_STATE: begin
                counting <= 1'b1;
                if (done_counting) begin
                    state <= NOTIFY;
                end else begin
                    state <= COUNTING_STATE;
                end
            end
            NOTIFY: begin
                done <= 1'b1;
                if (ack) begin
                    state <= ACK_WAIT;
                end else begin
                    state <= NOTIFY;
                end
            end
            ACK_WAIT: begin
                if (ack) begin
                    state <= IDLE;
                end else begin
                    state <= ACK_WAIT;
                end
            end
            default: begin
                state <= IDLE;
                shift_ena <= 1'b0;
                counting <= 1'b0;
                done <= 1'b0;
            end
        endcase
    end
end

always @(*) begin
    case (state)
        IDLE: begin
            shift_ena = 1'b0;
            counting = 1'b0;
            done = 1'b0;
        end
        DETECT_PATTERN: begin
            shift_ena = 1'b1;
            counting = 1'b0;
            done = 1'b0;
        end
        SHIFT_IN: begin
            shift_ena = 1'b1;
            counting = 1'b0;
            done = 1'b0;
        end
        COUNTING_STATE: begin
            shift_ena = 1'b0;
            counting = 1'b1;
            done = 1'b0;
        end
        NOTIFY: begin
            shift_ena = 1'b0;
            counting = 1'b0;
            done = 1'b1;
        end
        ACK_WAIT: begin
            shift_ena = 1'b0;
            counting = 1'b0;
            done = 1'b1;
        end
        default: begin
            shift_ena = 1'b0;
            counting = 1'b0;
            done = 1'b0;
        end
    endcase
end
endmodule