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
enum logic [1:0] {
    IDLE,
    SHIFT,
    COUNT,
    DONE
} state, next_state;

// Define counters
reg [1:0] shift_count;
reg [3:0] pattern;
reg pattern_detected;
reg shifting_complete;
reg counting_complete;

// Initialize signals
initial begin
    state = IDLE;
    shift_ena = 0;
    counting = 0;
    done = 0;
    shift_count = 0;
    pattern = 0;
    pattern_detected = 0;
    shifting_complete = 0;
    counting_complete = 0;
end

// State machine logic
always @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        shift_ena <= 0;
        counting <= 0;
        done <= 0;
        shift_count <= 0;
        pattern <= 0;
        pattern_detected <= 0;
        shifting_complete <= 0;
        counting_complete <= 0;
    end
    else begin
        case (state)
            IDLE: begin
                // Pattern detection logic
                pattern <= {data, pattern[3:1]};
                if (pattern == 4'b1101) begin
                    pattern_detected <= 1;
                    next_state <= SHIFT;
                end
                else begin
                    pattern_detected <= 0;
                    next_state <= IDLE;
                end
                shift_ena <= 0;
                counting <= 0;
                done <= 0;
            end
            SHIFT: begin
                // Shifting logic
                shift_ena <= 1;
                shift_count <= shift_count + 1;
                if (shift_count == 4) begin
                    shifting_complete <= 1;
                    next_state <= COUNT;
                end
                else begin
                    next_state <= SHIFT;
                end
                counting <= 0;
                done <= 0;
            end
            COUNT: begin
                // Counting logic
                shift_ena <= 0;
                counting <= 1;
                if (done_counting) begin
                    counting_complete <= 1;
                    next_state <= DONE;
                end
                else begin
                    next_state <= COUNT;
                end
                done <= 0;
            end
            DONE: begin
                // Done logic
                shift_ena <= 0;
                counting <= 0;
                done <= 1;
                if (ack) begin
                    next_state <= IDLE;
                end
                else begin
                    next_state <= DONE;
                end
            end
        endcase
        state <= next_state;
        if (next_state == IDLE) begin
            shift_count <= 0;
            pattern <= 0;
            pattern_detected <= 0;
            shifting_complete <= 0;
            counting_complete <= 0;
        end
        else if (next_state == COUNT) begin
            shifting_complete <= 0;
        end
        else if (next_state == DONE) begin
            counting_complete <= 0;
        end
    end
end

endmodule