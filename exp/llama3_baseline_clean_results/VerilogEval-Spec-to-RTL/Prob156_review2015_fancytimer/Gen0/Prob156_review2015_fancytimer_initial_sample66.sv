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
reg [9:0] counter;
reg [3:0] remaining_time;
reg [3:0] pattern;
reg counting_reg;
reg done_reg;

enum logic [1:0] {
    IDLE,
    PATTERN_DETECT,
    COUNTING,
    DONE
} state, next_state;

always @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        pattern <= 0;
        counting_reg <= 0;
        done_reg <= 0;
        counter <= 0;
    end else begin
        state <= next_state;
        case (state)
            IDLE: begin
                if (data == 1'b1) begin
                    pattern <= {pattern[2:0], 1'b1};
                end else begin
                    pattern <= {pattern[2:0], 1'b0};
                end
                if (pattern == 4'b1101) begin
                    pattern <= 0;
                    state <= PATTERN_DETECT;
                end
            end
            PATTERN_DETECT: begin
                delay <= {delay[2:0], data};
                if (delay[3] == 1'b1) begin
                    state <= COUNTING;
                    remaining_time <= delay + 1;
                    counting_reg <= 1;
                end
            end
            COUNTING: begin
                if (counter == 1000) begin
                    counter <= 0;
                    if (remaining_time > 1) begin
                        remaining_time <= remaining_time - 1;
                    end else begin
                        counting_reg <= 0;
                        state <= DONE;
                        done_reg <= 1;
                    end
                end else begin
                    counter <= counter + 1;
                end
            end
            DONE: begin
                if (ack) begin
                    done_reg <= 0;
                    state <= IDLE;
                end
            end
        endcase
    end
end

assign count = (state == COUNTING) ? remaining_time - 1 : 4'bxxxx;
assign counting = counting_reg;
assign done = done_reg;

endmodule