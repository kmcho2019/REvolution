module TopModule(
    input clk,
    input reset,
    input data,
    output [3:0] count,
    output counting,
    output done,
    input ack
);

reg [3:0] count_reg;
reg counting_reg;
reg done_reg;
reg [3:0] delay_reg;
reg [3:0] remaining_time_reg;
reg [3:0] counter_reg;
reg [3:0] shift_reg;
reg [3:0] pattern_reg;

// Define the states
enum logic [1:0] {IDLE, SHIFT, COUNT, DONE} state, next_state;

always @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        count_reg <= 4'b0;
        counting_reg <= 1'b0;
        done_reg <= 1'b0;
        delay_reg <= 4'b0;
        remaining_time_reg <= 4'b0;
        counter_reg <= 4'b0;
        shift_reg <= 4'b0;
        pattern_reg <= 4'b0;
    end else begin
        state <= next_state;
        case (state)
            IDLE: begin
                if (data == 1'b1 && pattern_reg == 4'b110) begin
                    pattern_reg <= {pattern_reg[2:0], data};
                    if (pattern_reg == 4'b1101) begin
                        pattern_reg <= 4'b0;
                        next_state <= SHIFT;
                    end else begin
                        next_state <= IDLE;
                    end
                end else if (data == 1'b0 && pattern_reg == 4'b11) begin
                    pattern_reg <= {pattern_reg[2:0], data};
                    next_state <= IDLE;
                end else if (data == 1'b1 && pattern_reg == 4'b1) begin
                    pattern_reg <= {pattern_reg[2:0], data};
                    next_state <= IDLE;
                end else if (data == 1'b1 && pattern_reg == 4'b0) begin
                    pattern_reg <= {pattern_reg[2:0], data};
                    next_state <= IDLE;
                end else begin
                    pattern_reg <= {pattern_reg[2:0], data};
                    next_state <= IDLE;
                end
            end
            SHIFT: begin
                shift_reg <= shift_reg + 1'b1;
                delay_reg[3-shift_reg] <= data;
                if (shift_reg == 4'b1000) begin
                    next_state <= COUNT;
                end else begin
                    next_state <= SHIFT;
                end
            end
            COUNT: begin
                if (counter_reg == 4'b1000 - 1'b1) begin
                    counter_reg <= 4'b0;
                    remaining_time_reg <= remaining_time_reg - 1'b1;
                    if (remaining_time_reg == 4'b0) begin
                        next_state <= DONE;
                    end else begin
                        next_state <= COUNT;
                    end
                end else begin
                    counter_reg <= counter_reg + 1'b1;
                    next_state <= COUNT;
                end
            end
            DONE: begin
                if (ack == 1'b1) begin
                    next_state <= IDLE;
                end else begin
                    next_state <= DONE;
                end
            end
        endcase
    end
end

always @(*) begin
    case (state)
        IDLE: begin
            counting_reg = 1'b0;
            done_reg = 1'b0;
            count_reg = 4'b0;
        end
        SHIFT: begin
            counting_reg = 1'b0;
            done_reg = 1'b0;
            count_reg = 4'b0;
        end
        COUNT: begin
            counting_reg = 1'b1;
            done_reg = 1'b0;
            count_reg = remaining_time_reg;
        end
        DONE: begin
            counting_reg = 1'b0;
            done_reg = 1'b1;
            count_reg = 4'b0;
        end
    endcase
end

always @(posedge clk) begin
    if (state == IDLE && pattern_reg == 4'b1101) begin
        remaining_time_reg <= delay_reg;
    end
end

assign count = count_reg;
assign counting = counting_reg;
assign done = done_reg;

endmodule