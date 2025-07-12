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

// Pattern detection logic
always @(posedge clk) begin
    if (reset) begin
        pattern <= 0;
        pattern_detected <= 0;
    end
    else if (state == IDLE) begin
        pattern <= {data, pattern[3:1]};
        if (pattern == 4'b1101) begin
            pattern_detected <= 1;
        end
        else begin
            pattern_detected <= 0;
        end
    end
end

// Shifting logic
always @(posedge clk) begin
    if (reset) begin
        shift_ena <= 0;
        shift_count <= 0;
        shifting_complete <= 0;
    end
    else if (state == SHIFT) begin
        shift_ena <= 1;
        shift_count <= shift_count + 1;
        if (shift_count == 4) begin
            shift_ena <= 0;
            shifting_complete <= 1;
        end
    end
    else if (state!= SHIFT) begin
        shift_ena <= 0;
        shift_count <= 0;
        shifting_complete <= 0;
    end
end

// Counting logic
always @(posedge clk) begin
    if (reset) begin
        counting <= 0;
        counting_complete <= 0;
    end
    else if (state == COUNT) begin
        counting <= 1;
        if (done_counting) begin
            counting_complete <= 1;
        end
    end
    else if (state!= COUNT) begin
        counting <= 0;
        counting_complete <= 0;
    end
end

// Done logic
always @(posedge clk) begin
    if (reset) begin
        done <= 0;
    end
    else if (state == DONE) begin
        done <= 1;
    end
    else begin
        done <= 0;
    end
end

// State machine logic
always @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
    end
    else begin
        case (state)
            IDLE: begin
                if (pattern_detected) begin
                    state <= SHIFT;
                end
                else begin
                    state <= IDLE;
                end
            end
            SHIFT: begin
                if (shifting_complete) begin
                    state <= COUNT;
                end
                else begin
                    state <= SHIFT;
                end
            end
            COUNT: begin
                if (counting_complete) begin
                    state <= DONE;
                end
                else begin
                    state <= COUNT;
                end
            end
            DONE: begin
                if (ack) begin
                    state <= IDLE;
                end
                else begin
                    state <= DONE;
                end
            end
        endcase
    end
end

endmodule