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
reg [1:0] state;
parameter IDLE = 2'b00;
parameter SHIFT = 2'b01;
parameter COUNT = 2'b10;
parameter WAIT_ACK = 2'b11;

// Define pattern detection states
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

// Next state logic
always @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        pattern_state <= PATTERN_IDLE;
        pattern <= 0;
        duration <= 0;
        shift_count <= 0;
    end
    else begin
        case (state)
            IDLE: begin
                if (pattern == 4'b1101) begin
                    state <= SHIFT;
                end
            end
            SHIFT: begin
                if (shift_count == 4) begin
                    state <= COUNT;
                end
                else begin
                    shift_count <= shift_count + 1;
                end
            end
            COUNT: begin
                if (done_counting) begin
                    state <= WAIT_ACK;
                end
            end
            WAIT_ACK: begin
                if (ack) begin
                    state <= IDLE;
                end
            end
        endcase

        // Pattern detection logic
        case (pattern_state)
            PATTERN_IDLE: begin
                pattern <= {pattern[2:0], data};
                if (pattern == 4'b1101) begin
                    pattern_state <= PATTERN_DETECT;
                end
            end
            PATTERN_DETECT: begin
                pattern_state <= PATTERN_IDLE;
            end
        endcase

        // Output logic
        shift_ena <= (state == SHIFT);
        counting <= (state == COUNT);
        done <= (state == WAIT_ACK);
    end
end

// Shift logic
always @(posedge clk) begin
    if (state == SHIFT) begin
        duration <= {duration[2:0], data};
    end
end

endmodule