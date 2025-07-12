module TopModule(
    input clk,
    input reset,
    input data,
    output [3:0] count,
    output counting,
    output done,
    input ack
);

reg [3:0] state; // 0: IDLE, 1: SHIFT_DELAY, 2: COUNTING, 3: DONE
reg [3:0] delay; // 4-bit delay value
reg [9:0] counter; // counter for clock cycles
reg [3:0] remaining_time; // remaining time to be displayed on count output
reg [3:0] pattern; // shift register for pattern detection

always @(posedge clk) begin
    if (reset) begin
        state <= 0; // IDLE
        pattern <= 0;
        delay <= 0;
        counter <= 0;
        remaining_time <= 0;
        counting <= 0;
        done <= 0;
    end else begin
        case (state)
            0: begin // IDLE
                // shift in data
                pattern <= {pattern[2:0], data};
                if (pattern == 4'b1101) begin
                    state <= 1; // SHIFT_DELAY
                    pattern <= 0;
                end
            end
            1: begin // SHIFT_DELAY
                // shift in delay value
                delay <= {delay[2:0], data};
                pattern <= {pattern[2:0], 1'b0};
                if (pattern == 4'b0000) begin
                    state <= 2; // COUNTING
                    counter <= 0;
                    remaining_time <= delay;
                end
            end
            2: begin // COUNTING
                counting <= 1;
                counter <= counter + 1;
                if (counter == 1000) begin
                    counter <= 0;
                    remaining_time <= remaining_time - 1;
                    if (remaining_time == 0) begin
                        state <= 3; // DONE
                        counting <= 0;
                    end
                end
            end
            3: begin // DONE
                done <= 1;
                if (ack) begin
                    state <= 0; // IDLE
                    done <= 0;
                end
            end
        endcase
    end
end

assign count = (state == 2) ? remaining_time : 4'bxxxx;

endmodule