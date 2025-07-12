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

// Define top-level states
reg [1:0] state;
parameter IDLE = 2'b00;
parameter SHIFT = 2'b01;
parameter COUNT = 2'b10;
parameter WAIT_ACK = 2'b11;

// Define pattern detection sub-state machine states
reg [1:0] pattern_state;
parameter PATTERN_IDLE = 2'b00;
parameter PATTERN_DETECT = 2'b01;

// Define registers
reg [3:0] pattern;
reg [3:0] duration;
reg [1:0] shift_count;

// Initialize signals
initial begin
    state = IDLE;
    pattern_state = PATTERN_IDLE;
    pattern = 0;
    duration = 0;
    shift_count = 0;
    shift_ena = 0;
    counting = 0;
    done = 0;
end

// Pattern detection sub-state machine
always @(posedge clk) begin
    if (reset) begin
        pattern_state <= PATTERN_IDLE;
        pattern <= 0;
    end
    else begin
        case (pattern_state)
            PATTERN_IDLE: begin
                pattern <= {pattern[2:0], data};
                if (pattern == 4'b1101) begin
                    pattern_state <= PATTERN_DETECT;
                end
            end
            PATTERN_DETECT: begin
                // Transition to SHIFT state in top-level state machine
                pattern_state <= PATTERN_IDLE;
            end
        endcase
    end
end

// Top-level state machine
always @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        duration <= 0;
        shift_count <= 0;
        shift_ena <= 0;
        counting <= 0;
        done <= 0;
    end
    else begin
        case (state)
            IDLE: begin
                if (pattern_state == PATTERN_DETECT) begin
                    state <= SHIFT;
                    shift_ena <= 1;
                end
                counting <= 0;
                done <= 0;
            end
            SHIFT: begin
                if (shift_count == 4) begin
                    shift_ena <= 0;
                    state <= COUNT;
                end
                else begin
                    duration <= {duration[2:0], data};
                    shift_count <= shift_count + 1;
                end
                counting <= 0;
                done <= 0;
            end
            COUNT: begin
                counting <= 1;
                if (done_counting) begin
                    state <= WAIT_ACK;
                end
                done <= 0;
            end
            WAIT_ACK: begin
                done <= 1;
                if (ack) begin
                    state <= IDLE;
                end
                shift_ena <= 0;
                counting <= 0;
            end
        endcase
    end
end

endmodule