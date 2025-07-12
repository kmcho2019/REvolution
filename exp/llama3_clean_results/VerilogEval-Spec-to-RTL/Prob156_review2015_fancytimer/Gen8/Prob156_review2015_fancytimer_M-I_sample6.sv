module TopModule (
    input clk,
    input reset,
    input data,
    output logic [3:0] count,
    output logic counting,
    output logic done,
    input ack
);

enum logic [1:0] {IDLE, SHIFT, COUNT, DONE} state, next_state;
logic [3:0] delay;
logic [9:0] remaining_time;
logic [3:0] shift_count;
logic [3:0] pattern;

always_ff @ (posedge clk) begin
    if (reset) begin
        state <= IDLE;
        delay <= 0;
        remaining_time <= 0;
        shift_count <= 0;
        pattern <= 0;
    end else begin
        case (state)
            IDLE: begin
                if (data == 1'b1) begin
                    pattern <= {data, pattern[2:0]};
                    if (pattern == 4'b1101) begin
                        next_state <= SHIFT;
                    end else begin
                        next_state <= IDLE;
                    end
                end else begin
                    pattern <= 0;
                    next_state <= IDLE;
                end
            end
            SHIFT: begin
                delay <= {data, delay[2:0]};
                shift_count <= shift_count + 1;
                if (shift_count == 4) begin
                    next_state <= COUNT;
                    remaining_time <= (delay + 1) * 1000;
                    shift_count <= 0;
                end else begin
                    next_state <= SHIFT;
                end
            end
            COUNT: begin
                remaining_time <= remaining_time - 1;
                if (remaining_time == 0) begin
                    next_state <= DONE;
                end else begin
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
            default: next_state <= IDLE;
        endcase
        state <= next_state;
    end
end

always_comb begin
    counting = (state == COUNT);
    done = (state == DONE);
    if (remaining_time > 999) begin
        count = (remaining_time / 1000) - 1;
    end else begin
        count = 0;
    end
end

endmodule