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
reg [2:0] state;
parameter IDLE = 3'b000;
parameter PATTERN_DETECT = 3'b001;
parameter SHIFT = 3'b010;
parameter COUNT = 3'b011;
parameter WAIT_ACK = 3'b100;

// Define sub-state machines
reg [3:0] pattern_detect_state;
parameter PATTERN_DETECT_IDLE = 4'b0000;
parameter PATTERN_DETECT_FOUND = 4'b0001;

reg [1:0] shift_state;
parameter SHIFT_IDLE = 2'b00;
parameter SHIFT_COUNTING = 2'b01;
parameter SHIFT_DONE = 2'b10;

reg [1:0] count_state;
parameter COUNT_IDLE = 2'b00;
parameter COUNT_WAITING = 2'b01;

reg [1:0] wait_ack_state;
parameter WAIT_ACK_IDLE = 2'b00;
parameter WAIT_ACK_WAITING = 2'b01;

// Define registers
reg [3:0] shift_count;
reg [3:0] pattern;
reg [3:0] duration;

// Initialize signals
initial begin
    state = IDLE;
    pattern_detect_state = PATTERN_DETECT_IDLE;
    shift_state = SHIFT_IDLE;
    count_state = COUNT_IDLE;
    wait_ack_state = WAIT_ACK_IDLE;
    shift_count = 0;
    pattern = 0;
    duration = 0;
    shift_ena = 0;
    counting = 0;
    done = 0;
end

// Main logic
always @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        pattern_detect_state <= PATTERN_DETECT_IDLE;
        shift_state <= SHIFT_IDLE;
        count_state <= COUNT_IDLE;
        wait_ack_state <= WAIT_ACK_IDLE;
        shift_count <= 0;
        pattern <= 0;
        duration <= 0;
        shift_ena <= 0;
        counting <= 0;
        done <= 0;
    end
    else begin
        case (state)
            IDLE: begin
                pattern_detect_state <= PATTERN_DETECT_IDLE;
                if (pattern_detect_state == PATTERN_DETECT_FOUND) begin
                    state <= PATTERN_DETECT;
                end
                shift_ena <= 0;
                counting <= 0;
                done <= 0;
            end
            PATTERN_DETECT: begin
                pattern_detect_state <= PATTERN_DETECT_FOUND;
                state <= SHIFT;
                shift_ena <= 1;
                shift_state <= SHIFT_COUNTING;
            end
            SHIFT: begin
                if (shift_state == SHIFT_COUNTING) begin
                    if (shift_count == 4) begin
                        shift_state <= SHIFT_DONE;
                        shift_ena <= 0;
                        state <= COUNT;
                    end
                    else begin
                        duration <= {duration[2:0], data};
                        shift_count <= shift_count + 1;
                    end
                end
                counting <= 0;
                done <= 0;
            end
            COUNT: begin
                counting <= 1;
                if (done_counting) begin
                    count_state <= COUNT_WAITING;
                    state <= WAIT_ACK;
                end
                done <= 0;
            end
            WAIT_ACK: begin
                done <= 1;
                if (wait_ack_state == WAIT_ACK_WAITING) begin
                    if (ack) begin
                        wait_ack_state <= WAIT_ACK_IDLE;
                        state <= IDLE;
                    end
                end
                shift_ena <= 0;
                counting <= 0;
            end
        endcase
    end
end

// Pattern detection sub-state machine
always @(posedge clk) begin
    if (reset) begin
        pattern_detect_state <= PATTERN_DETECT_IDLE;
        pattern <= 0;
    end
    else begin
        case (pattern_detect_state)
            PATTERN_DETECT_IDLE: begin
                pattern <= {pattern[2:0], data};
                if (pattern == 4'b1101) begin
                    pattern_detect_state <= PATTERN_DETECT_FOUND;
                end
            end
            PATTERN_DETECT_FOUND: begin
                // Do nothing
            end
        endcase
    end
end

// Shift sub-state machine
always @(posedge clk) begin
    if (reset) begin
        shift_state <= SHIFT_IDLE;
        shift_count <= 0;
    end
    else begin
        case (shift_state)
            SHIFT_IDLE: begin
                // Do nothing
            end
            SHIFT_COUNTING: begin
                if (shift_count == 4) begin
                    shift_state <= SHIFT_DONE;
                end
                else begin
                    shift_count <= shift_count + 1;
                end
            end
            SHIFT_DONE: begin
                // Do nothing
            end
        endcase
    end
end

// Count sub-state machine
always @(posedge clk) begin
    if (reset) begin
        count_state <= COUNT_IDLE;
    end
    else begin
        case (count_state)
            COUNT_IDLE: begin
                // Do nothing
            end
            COUNT_WAITING: begin
                if (done_counting) begin
                    count_state <= COUNT_IDLE;
                end
            end
        endcase
    end
end

// Wait acknowledgement sub-state machine
always @(posedge clk) begin
    if (reset) begin
        wait_ack_state <= WAIT_ACK_IDLE;
    end
    else begin
        case (wait_ack_state)
            WAIT_ACK_IDLE: begin
                // Do nothing
            end
            WAIT_ACK_WAITING: begin
                if (ack) begin
                    wait_ack_state <= WAIT_ACK_IDLE;
                end
            end
        endcase
    end
end

endmodule