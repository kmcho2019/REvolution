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
reg [3:0] remaining_time;
reg [3:0] pattern;
reg [2:0] shift_count;
reg [11:0] clock_count;
reg counting_int;
reg done_int;

enum logic [2:0] {IDLE, SHIFT, COUNT, DONE} state, next_state;

always @(*) begin
    next_state = state;
    case (state)
        IDLE: begin
            if (pattern == 4'b1101) begin
                next_state = SHIFT;
            end else if (reset) begin
                next_state = IDLE;
            end
        end
        SHIFT: begin
            if (shift_count == 4) begin
                next_state = COUNT;
            end else if (reset) begin
                next_state = IDLE;
            end
        end
        COUNT: begin
            if (clock_count == (delay + 1) * 1000 - 1) begin
                next_state = DONE;
            end else if (reset) begin
                next_state = IDLE;
            end
        end
        DONE: begin
            if (ack) begin
                next_state = IDLE;
            end else if (reset) begin
                next_state = IDLE;
            end
        end
    endcase
end

always @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        pattern <= 0;
        shift_count <= 0;
        delay <= 0;
        remaining_time <= 0;
        clock_count <= 0;
        counting_int <= 0;
        done_int <= 0;
    end else begin
        state <= next_state;
        case (state)
            IDLE: begin
                if (data) begin
                    pattern <= {pattern[2:0], 1'b1};
                end else begin
                    pattern <= {pattern[2:0], 1'b0};
                end
            end
            SHIFT: begin
                if (data) begin
                    delay <= {delay[2:0], 1'b1};
                end else begin
                    delay <= {delay[2:0], 1'b0};
                end
                shift_count <= shift_count + 1;
            end
            COUNT: begin
                clock_count <= clock_count + 1;
                if (clock_count % 1000 == 0) begin
                    remaining_time <= remaining_time - 1;
                end
            end
            DONE: begin
                // do nothing
            end
        endcase
        counting_int <= (state == COUNT);
        done_int <= (state == DONE);
    end
end

assign counting = counting_int;
assign done = done_int;
assign count = remaining_time;
endmodule