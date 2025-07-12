module TopModule(
    input clk,
    input reset,
    input data,
    output reg [3:0] count,
    output reg counting,
    output reg done,
    input ack
);

// Define the states of the FSM
enum logic [2:0] {
    IDLE,
    SHIFT_DELAY,
    COUNTING,
    DONE
} state, next_state;

// Define the delay register
reg [3:0] delay;
reg [3:0] remaining;
reg [9:0] cycle_count;

// Define the pattern detection logic
reg [3:0] pattern;
reg pattern_detected;

// Pattern detection logic
always @(posedge clk) begin
    if (reset) begin
        pattern <= 4'b0000;
    end else if (state == IDLE) begin
        pattern <= {pattern[2:0], data};
        if (pattern == 4'b1101) begin
            pattern_detected <= 1'b1;
        end else begin
            pattern_detected <= 1'b0;
        end
    end else begin
        pattern_detected <= 1'b0;
    end
end

// State machine logic
always @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        counting <= 1'b0;
        done <= 1'b0;
    end else begin
        state <= next_state;
        case (state)
            IDLE: begin
                if (pattern_detected) begin
                    next_state <= SHIFT_DELAY;
                end else begin
                    next_state <= IDLE;
                end
            end
            SHIFT_DELAY: begin
                if (delay == 4'b0000) begin
                    next_state <= COUNTING;
                end else begin
                    next_state <= SHIFT_DELAY;
                    delay <= {data, delay[3:1]};
                end
            end
            COUNTING: begin
                if (cycle_count == 10'd999) begin
                    if (remaining == 4'b0000) begin
                        next_state <= DONE;
                    end else begin
                        next_state <= COUNTING;
                        remaining <= remaining - 1'b1;
                        cycle_count <= 10'd0;
                    end
                end else begin
                    next_state <= COUNTING;
                    cycle_count <= cycle_count + 1'b1;
                end
            end
            DONE: begin
                if (ack) begin
                    next_state <= IDLE;
                end else begin
                    next_state <= DONE;
                end
            end
        endcase
        case (state)
            IDLE: begin
                counting <= 1'b0;
                done <= 1'b0;
                count <= 4'b0000;
            end
            SHIFT_DELAY: begin
                counting <= 1'b0;
                done <= 1'b0;
                count <= 4'b0000;
            end
            COUNTING: begin
                counting <= 1'b1;
                done <= 1'b0;
                count <= remaining;
            end
            DONE: begin
                counting <= 1'b0;
                done <= 1'b1;
                count <= 4'b0000;
            end
        endcase
        if (state == IDLE) begin
            delay <= 4'b0000;
            remaining <= 4'b0000;
            cycle_count <= 10'd0;
        end
        if (state == SHIFT_DELAY && delay == 4'b1111) begin
            remaining <= delay + 1'b1;
        end
    end
end

endmodule