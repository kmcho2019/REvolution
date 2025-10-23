module TopModule(
    input clk,
    input reset,
    input data,
    output [3:0] count,
    output counting,
    output done,
    input ack
);

reg [3:0] state; // 0: idle, 1: shifting, 2: counting, 3: done
reg [3:0] delay; // stores the duration of the timer delay
reg [3:0] remaining_time; // stores the remaining time
reg [3:0] count_reg; // stores the current count
reg [3:0] pattern_reg; // stores the detected pattern
reg counting_reg;
reg done_reg;
reg [2:0] shift_counter; // counter for shifting in the next 4 bits
reg [9:0] timer_counter; // counter for counting down the duration

always @(posedge clk) begin
    if (reset) begin
        state <= 0; // idle
        pattern_reg <= 0;
        shift_counter <= 0;
        timer_counter <= 0;
        delay <= 0;
        remaining_time <= 0;
        count_reg <= 0;
        counting_reg <= 0;
        done_reg <= 0;
    end else begin
        case (state)
            0: begin // idle
                if (data == 1 && pattern_reg == 0) begin // detect the first bit of the pattern
                    pattern_reg <= 1;
                end else if (data == 1 && pattern_reg == 1) begin // detect the second bit of the pattern
                    pattern_reg <= 2;
                end else if (data == 0 && pattern_reg == 2) begin // detect the third bit of the pattern
                    pattern_reg <= 3;
                end else if (data == 1 && pattern_reg == 3) begin // detect the fourth bit of the pattern
                    pattern_reg <= 4;
                    state <= 1; // shifting
                end else if (data == 0 && pattern_reg == 4) begin // pattern not detected
                    pattern_reg <= 0;
                end else if (data == 0 && pattern_reg == 0) begin // reset the pattern register
                    pattern_reg <= 0;
                end
            end
            1: begin // shifting
                if (shift_counter == 0) begin
                    delay[3] <= data;
                end else if (shift_counter == 1) begin
                    delay[2] <= data;
                end else if (shift_counter == 2) begin
                    delay[1] <= data;
                end else if (shift_counter == 3) begin
                    delay[0] <= data;
                    state <= 2; // counting
                    remaining_time <= delay;
                    count_reg <= delay;
                    timer_counter <= 0;
                    counting_reg <= 1;
                end
                shift_counter <= shift_counter + 1;
            end
            2: begin // counting
                if (timer_counter == 999) begin // count for 1000 clock cycles
                    remaining_time <= remaining_time - 1;
                    count_reg <= remaining_time;
                    timer_counter <= 0;
                end else begin
                    timer_counter <= timer_counter + 1;
                end
                if (remaining_time == 0) begin
                    state <= 3; // done
                    done_reg <= 1;
                    counting_reg <= 0;
                end
            end
            3: begin // done
                if (ack) begin
                    state <= 0; // idle
                    done_reg <= 0;
                    pattern_reg <= 0;
                    shift_counter <= 0;
                    timer_counter <= 0;
                    delay <= 0;
                    remaining_time <= 0;
                    count_reg <= 0;
                end
            end
        endcase
    end
end

assign count = count_reg;
assign counting = counting_reg;
assign done = done_reg;

endmodule