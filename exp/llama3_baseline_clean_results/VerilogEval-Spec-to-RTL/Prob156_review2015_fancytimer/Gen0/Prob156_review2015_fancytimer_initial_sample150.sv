module TopModule(
    input clk,
    input reset,
    input data,
    output [3:0] count,
    output counting,
    output done,
    input ack
);

reg [3:0] delay;
reg [3:0] remaining_time;
reg [3:0] pattern;
reg [2:0] shift_count;
reg counting_reg;
reg done_reg;

enum logic [2:0] {
    IDLE,
    DELAY_LOAD,
    COUNTING,
    DONE
} state, next_state;

always_ff @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        pattern <= 0;
        shift_count <= 0;
        remaining_time <= 0;
        delay <= 0;
        counting_reg <= 0;
        done_reg <= 0;
    end else begin
        state <= next_state;
        case (state)
            IDLE: begin
                if (pattern == 4'b1101) begin
                    pattern <= 0;
                    state <= DELAY_LOAD;
                end else begin
                    pattern <= {pattern[2:0], data};
                end
            end
            DELAY_LOAD: begin
                delay <= {delay[2:0], data};
                shift_count <= shift_count + 1;
                if (shift_count == 4) begin
                    remaining_time <= delay + 1;
                    counting_reg <= 1;
                    state <= COUNTING;
                end
            end
            COUNTING: begin
                if (remaining_time == 1) begin
                    counting_reg <= 0;
                    state <= DONE;
                end else if (remaining_time == 1001) begin
                    remaining_time <= remaining_time - 1;
                end else if (remaining_time % 1000 == 1) begin
                    remaining_time <= remaining_time - 1;
                end
            end
            DONE: begin
                if (ack) begin
                    state <= IDLE;
                    done_reg <= 0;
                end
            end
        endcase
        count <= (state == COUNTING) ? remaining_time[3:0] : 4'bxxxx;
        counting <= counting_reg;
        done <= done_reg;
        if (state == DONE) begin
            done_reg <= 1;
        end
    end
end

always_comb begin
    case (state)
        IDLE: next_state = (pattern == 4'b1101) ? DELAY_LOAD : IDLE;
        DELAY_LOAD: next_state = (shift_count == 4) ? COUNTING : DELAY_LOAD;
        COUNTING: next_state = (remaining_time == 1) ? DONE : COUNTING;
        DONE: next_state = (ack) ? IDLE : DONE;
    endcase
end

endmodule