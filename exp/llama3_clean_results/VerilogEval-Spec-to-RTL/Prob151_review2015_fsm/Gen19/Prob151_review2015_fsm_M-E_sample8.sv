module TopModule(
    input  clk,
    input  reset,
    input  data,
    input  done_counting,
    input  ack,
    output reg shift_ena,
    output reg counting,
    output reg done
);

// Define the states of the top-level FSM
enum logic [2:0] {
    IDLE_STATE,
    SHIFTING_STATE,
    COUNTING_STATE,
    DONE_STATE
} current_state, next_state;

// Define the states of the pattern detection sub-FSM
enum logic [1:0] {
    PATTERN_IDLE,
    PATTERN_DETECTED
} pattern_state, next_pattern_state;

// Define the states of the shifting sub-FSM
enum logic [1:0] {
    SHIFT_IDLE,
    SHIFTING
} shift_state, next_shift_state;

// Define the states of the counting sub-FSM
enum logic [1:0] {
    COUNT_IDLE,
    COUNTING
} count_state, next_count_state;

// Define the states of the done notification sub-FSM
enum logic [1:0] {
    DONE_IDLE,
    DONE_NOTIFIED
} done_state, next_done_state;

// Pattern detection sub-FSM
always @(*) begin
    case (pattern_state)
        PATTERN_IDLE: begin
            if (data == 1'b1) begin
                next_pattern_state = PATTERN_DETECTED;
            end else begin
                next_pattern_state = PATTERN_IDLE;
            end
        end
        PATTERN_DETECTED: begin
            if (data == 1'b0) begin
                next_pattern_state = PATTERN_IDLE;
            end else begin
                next_pattern_state = PATTERN_DETECTED;
            end
        end
    endcase
end

// Shifting sub-FSM
reg [3:0] shift_counter;
always @(*) begin
    case (shift_state)
        SHIFT_IDLE: begin
            if (pattern_state == PATTERN_DETECTED) begin
                next_shift_state = SHIFTING;
            end else begin
                next_shift_state = SHIFT_IDLE;
            end
        end
        SHIFTING: begin
            if (shift_counter == 4'd4) begin
                next_shift_state = SHIFT_IDLE;
            end else begin
                next_shift_state = SHIFTING;
            end
        end
    endcase
end

// Counting sub-FSM
always @(*) begin
    case (count_state)
        COUNT_IDLE: begin
            if (shift_state == SHIFT_IDLE) begin
                next_count_state = COUNTING;
            end else begin
                next_count_state = COUNT_IDLE;
            end
        end
        COUNTING: begin
            if (done_counting) begin
                next_count_state = COUNT_IDLE;
            end else begin
                next_count_state = COUNTING;
            end
        end
    endcase
end

// Done notification sub-FSM
always @(*) begin
    case (done_state)
        DONE_IDLE: begin
            if (count_state == COUNT_IDLE) begin
                next_done_state = DONE_NOTIFIED;
            end else begin
                next_done_state = DONE_IDLE;
            end
        end
        DONE_NOTIFIED: begin
            if (ack) begin
                next_done_state = DONE_IDLE;
            end else begin
                next_done_state = DONE_NOTIFIED;
            end
        end
    endcase
end

// Top-level FSM
always @(*) begin
    case (current_state)
        IDLE_STATE: begin
            if (pattern_state == PATTERN_DETECTED) begin
                next_state = SHIFTING_STATE;
            end else begin
                next_state = IDLE_STATE;
            end
        end
        SHIFTING_STATE: begin
            if (shift_state == SHIFT_IDLE) begin
                next_state = COUNTING_STATE;
            end else begin
                next_state = SHIFTING_STATE;
            end
        end
        COUNTING_STATE: begin
            if (count_state == COUNT_IDLE) begin
                next_state = DONE_STATE;
            end else begin
                next_state = COUNTING_STATE;
            end
        end
        DONE_STATE: begin
            if (done_state == DONE_IDLE) begin
                next_state = IDLE_STATE;
            end else begin
                next_state = DONE_STATE;
            end
        end
    endcase
end

// Sequential logic for state and output updates
always @(posedge clk) begin
    if (reset) begin
        current_state <= IDLE_STATE;
        pattern_state <= PATTERN_IDLE;
        shift_state <= SHIFT_IDLE;
        count_state <= COUNT_IDLE;
        done_state <= DONE_IDLE;
        shift_counter <= 4'd0;
        shift_ena <= 1'b0;
        counting <= 1'b0;
        done <= 1'b0;
    end else begin
        pattern_state <= next_pattern_state;
        shift_state <= next_shift_state;
        count_state <= next_count_state;
        done_state <= next_done_state;
        current_state <= next_state;
        
        if (shift_state == SHIFTING) begin
            shift_counter <= shift_counter + 1'b1;
        end else begin
            shift_counter <= 4'd0;
        end
        
        case (current_state)
            IDLE_STATE: begin
                shift_ena <= 1'b0;
                counting <= 1'b0;
                done <= 1'b0;
            end
            SHIFTING_STATE: begin
                shift_ena <= 1'b1;
                counting <= 1'b0;
                done <= 1'b0;
            end
            COUNTING_STATE: begin
                shift_ena <= 1'b0;
                counting <= 1'b1;
                done <= 1'b0;
            end
            DONE_STATE: begin
                shift_ena <= 1'b0;
                counting <= 1'b0;
                done <= 1'b1;
            end
        endcase
    end
end

endmodule