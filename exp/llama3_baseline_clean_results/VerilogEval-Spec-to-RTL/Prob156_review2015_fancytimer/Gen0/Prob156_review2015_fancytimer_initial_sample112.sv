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
reg [3:0] curr_count;
reg [9:0] cycle_count;
reg [3:0] pattern;
reg counting_reg;
reg done_reg;

enum logic [2:0] {
    IDLE,
    SHIFT,
    COUNTING,
    DONE
} state, next_state;

always @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        pattern <= 4'b0000;
        counting_reg <= 1'b0;
        done_reg <= 1'b0;
        cycle_count <= 10'b0;
        curr_count <= 4'b0000;
        delay <= 4'b0000;
    end
    else begin
        case (state)
            IDLE: begin
                pattern <= {data, pattern[3:1]};
                if (pattern == 4'b1101) begin
                    state <= SHIFT;
                end
                else begin
                    state <= IDLE;
                end
            end
            SHIFT: begin
                delay <= {data, delay[3:1]};
                if (delay[3] == 1'b1) begin
                    state <= COUNTING;
                    curr_count <= delay + 1'b1;
                    counting_reg <= 1'b1;
                end
                else begin
                    state <= SHIFT;
                end
            end
            COUNTING: begin
                if (cycle_count == 10'b1111101000) begin
                    cycle_count <= 10'b0;
                    if (curr_count > 4'b0000) begin
                        curr_count <= curr_count - 1'b1;
                    end
                    else begin
                        state <= DONE;
                        done_reg <= 1'b1;
                        counting_reg <= 1'b0;
                    end
                end
                else begin
                    cycle_count <= cycle_count + 1'b1;
                end
            end
            DONE: begin
                if (ack) begin
                    state <= IDLE;
                    done_reg <= 1'b0;
                end
                else begin
                    state <= DONE;
                end
            end
        endcase
    end
end

assign count = (state == COUNTING) ? curr_count : 4'bxxxx;
assign counting = counting_reg;
assign done = done_reg;

endmodule