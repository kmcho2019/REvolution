module TopModule(
    input clk,
    input reset,
    input data,
    output reg [3:0] count,
    output reg counting,
    output reg done,
    input ack
);

reg [3:0] delay;
reg [15:0] remaining_time;
reg [3:0] current_count;
reg [3:0] pattern;
reg pattern_valid;

enum logic [2:0] {IDLE, SHIFT, COUNT, DONE} state, next_state;

always @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        pattern_valid <= 1'b0;
        pattern <= 4'b0000;
        delay <= 4'b0000;
        remaining_time <= 16'b0000;
        current_count <= 4'b0000;
        count <= 4'b0000;
        counting <= 1'b0;
        done <= 1'b0;
    end else begin
        state <= next_state;
        case (state)
            IDLE: begin
                if (pattern_valid) begin
                    pattern_valid <= 1'b0;
                    pattern <= {pattern[2:0], data};
                    if (pattern == 4'b1101) begin
                        next_state <= SHIFT;
                    end else begin
                        next_state <= IDLE;
                    end
                end else begin
                    pattern <= {3'b000, data};
                    pattern_valid <= 1'b1;
                    next_state <= IDLE;
                end
            end
            SHIFT: begin
                delay <= {delay[2:0], data};
                if (delay[0] == 1'b1) begin
                    next_state <= COUNT;
                end else begin
                    next_state <= SHIFT;
                end
            end
            COUNT: begin
                if (remaining_time == 16'b0000) begin
                    done <= 1'b1;
                    next_state <= DONE;
                end else begin
                    remaining_time <= remaining_time - 1;
                    current_count <= delay;
                    if (remaining_time[15:12] == 4'b0000) begin
                        current_count <= current_count - 1;
                    end
                    count <= current_count;
                    counting <= 1'b1;
                    next_state <= COUNT;
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
    end
end

always @(posedge clk) begin
    if (state == COUNT) begin
        remaining_time <= (delay + 1) * 1000 - 1;
    end
end

always @(posedge clk) begin
    if (state == IDLE || state == SHIFT) begin
        counting <= 1'b0;
    end
end

always @(posedge clk) begin
    if (state == DONE) begin
        counting <= 1'b0;
    end
end

always @(posedge clk) begin
    if (state == IDLE) begin
        done <= 1'b0;
    end
end

endmodule