module TopModule(
    input clk,
    input reset,
    input data,
    input done_counting,
    input ack,
    output shift_ena,
    output counting,
    output done
);

// Define states
enum logic [2:0] {
    IDLE = 3'b001,
    WAIT_SHIFT = 3'b010,
    SHIFT = 3'b011,
    COUNT = 3'b100,
    DONE = 3'b101
} state, next_state;

// Shift counter
logic [1:0] shift_count;
logic [3:0] pattern;
logic pattern_detected;

// Pattern detection
always @(*) begin
    pattern_detected = (pattern == 4'b1101);
end

// Shift counter
always @(posedge clk) begin
    if (reset) begin
        shift_count <= 2'b00;
    end else if (state == SHIFT) begin
        shift_count <= shift_count + 1'b1;
    end else begin
        shift_count <= 2'b00;
    end
end

// Pattern detection
always @(posedge clk) begin
    if (reset) begin
        pattern <= 4'b0000;
    end else if (state == IDLE || state == WAIT_SHIFT) begin
        pattern <= {pattern[2:0], data};
    end else begin
        pattern <= 4'b0000;
    end
end

// Next state logic
always @(*) begin
    next_state = state;
    shift_ena = 1'b0;
    counting = 1'b0;
    done = 1'b0;
    case (state)
        IDLE: begin
            if (pattern_detected) begin
                next_state = WAIT_SHIFT;
            end
        end
        WAIT_SHIFT: begin
            next_state = SHIFT;
            shift_ena = 1'b1;
        end
        SHIFT: begin
            if (shift_count == 2'b11) begin
                next_state = COUNT;
            end else begin
                shift_ena = 1'b1;
            end
        end
        COUNT: begin
            counting = 1'b1;
            if (done_counting) begin
                next_state = DONE;
            end
        end
        DONE: begin
            done = 1'b1;
            if (ack) begin
                next_state = IDLE;
            end
        end
    endcase
end

// State register
always @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
    end else begin
        state <= next_state;
    end
end

endmodule