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
enum logic [2:0] {IDLE, PATTERN_DETECTED, SHIFTING, COUNTING, TIMEOUT} state, next_state;

// Define the bits to match the pattern
logic [3:0] pattern;

// Counter for shifting
logic [1:0] shift_count;

// Flag for pattern detected
logic pattern_detected;

always_comb begin
    next_state = state;
    case (state)
        IDLE: begin
            if (pattern == 4'b1101) begin
                next_state = PATTERN_DETECTED;
            end
        end
        PATTERN_DETECTED: begin
            next_state = SHIFTING;
        end
        SHIFTING: begin
            if (shift_count == 2'd3) begin
                next_state = COUNTING;
            end
        end
        COUNTING: begin
            if (done_counting) begin
                next_state = TIMEOUT;
            end
        end
        TIMEOUT: begin
            if (ack) begin
                next_state = IDLE;
            end
        end
    endcase
end

always_ff @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        pattern <= 4'b0000;
        shift_count <= 2'b00;
        pattern_detected <= 1'b0;
    end else begin
        state <= next_state;
        if (state == IDLE) begin
            pattern <= {pattern[2:0], data};
        end
        if (state == SHIFTING) begin
            shift_count <= shift_count + 1'b1;
        end
        if (state == TIMEOUT) begin
            if (ack) begin
                pattern <= 4'b0000;
                shift_count <= 2'b00;
            end
        end
    end
end

always_comb begin
    shift_ena = 1'b0;
    counting = 1'b0;
    done = 1'b0;
    case (state)
        IDLE: begin
        end
        PATTERN_DETECTED: begin
            shift_ena = 1'b1;
        end
        SHIFTING: begin
            shift_ena = 1'b1;
        end
        COUNTING: begin
            counting = 1'b1;
        end
        TIMEOUT: begin
            done = 1'b1;
        end
    endcase
end

endmodule