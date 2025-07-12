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
        count <= 0;
    end else begin
        case (state)
            IDLE: begin
                pattern <= {data, pattern[2:0]};
                if (pattern == 4'b1101) begin
                    state <= SHIFT;
                end
            end
            SHIFT: begin
                delay <= {data, delay[2:0]};
                shift_count <= shift_count + 1;
                if (shift_count == 4) begin
                    state <= COUNT;
                    remaining_time <= (delay + 1) * 1000;
                end
            end
            COUNT: begin
                if (remaining_time > 0) begin
                    remaining_time <= remaining_time - 1;
                    if (remaining_time % 1000 == 0) begin
                        count <= count - 1;
                    end
                end else begin
                    state <= DONE;
                end
            end
            DONE: begin
                if (ack) begin
                    state <= IDLE;
                end
            end
        endcase
    end
end

always_comb begin
    counting = (state == COUNT);
    done = (state == DONE);
end

endmodule