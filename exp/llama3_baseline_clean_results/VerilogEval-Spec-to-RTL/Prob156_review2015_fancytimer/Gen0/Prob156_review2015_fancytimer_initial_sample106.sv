module TopModule(
    input  clk,
    input  reset,
    input  data,
    output reg [3:0] count,
    output reg counting,
    output reg done,
    input  ack
);

reg [3:0] delay; // delay counter
reg [3:0] counter; // counter to keep track of remaining time
reg [3:0] pattern; // pattern to detect '1101'
reg [2:0] shift_counter; // counter for shifting in delay[3:0]
reg [9:0] timer_counter; // counter to count for 1000 clock cycles
reg state_idle, state_shift, state_counting, state_done;

always @(posedge clk) begin
    if (reset) begin
        state_idle <= 1'b1;
        state_shift <= 1'b0;
        state_counting <= 1'b0;
        state_done <= 1'b0;
        pattern <= 4'b0;
        shift_counter <= 3'b0;
        delay <= 4'b0;
        counter <= 4'b0;
        timer_counter <= 10'b0;
        counting <= 1'b0;
        done <= 1'b0;
        count <= 4'b0;
    end else begin
        case ({state_idle, state_shift, state_counting, state_done})
            4'b1000: begin // IDLE state
                if (pattern == 4'b1101) begin
                    pattern <= 4'b0;
                    state_idle <= 1'b0;
                    state_shift <= 1'b1;
                end else begin
                    pattern <= {pattern[2:0], data};
                end
            end
            4'b0100: begin // SHIFT state
                delay <= {delay[2:0], data};
                if (shift_counter == 3'b111) begin
                    shift_counter <= 3'b0;
                    state_shift <= 1'b0;
                    state_counting <= 1'b1;
                    counter <= delay;
                    timer_counter <= 10'b0;
                    counting <= 1'b1;
                end else begin
                    shift_counter <= shift_counter + 1'b1;
                end
            end
            4'b0010: begin // COUNTING state
                if (timer_counter == 10'b1111101000) begin // 1000 clock cycles
                    timer_counter <= 10'b0;
                    if (counter == 4'b0) begin
                        state_counting <= 1'b0;
                        state_done <= 1'b1;
                        counting <= 1'b0;
                        done <= 1'b1;
                    end else begin
                        counter <= counter - 1'b1;
                    end
                end else begin
                    timer_counter <= timer_counter + 1'b1;
                end
                count <= counter;
            end
            4'b0001: begin // DONE state
                if (ack) begin
                    state_done <= 1'b0;
                    state_idle <= 1'b1;
                    done <= 1'b0;
                end
            end
        endcase
    end
end

endmodule