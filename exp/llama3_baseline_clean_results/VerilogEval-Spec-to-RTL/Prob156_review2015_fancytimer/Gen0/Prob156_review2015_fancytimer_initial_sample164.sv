module TopModule(
    input clk,
    input reset,
    input data,
    output reg [3:0] count,
    output reg counting,
    output reg done,
    input ack
);

reg [3:0] state; // 0: idle, 1: pattern detection, 2: counting, 3: done
reg [3:0] delay; // store the delay value
reg [3:0] remaining_time; // store the remaining time
reg [9:0] counter; // counter for clock cycles
reg [3:0] pattern; // store the input pattern

always @(posedge clk) begin
    if (reset) begin
        state <= 0;
        counting <= 0;
        done <= 0;
        counter <= 0;
        remaining_time <= 0;
        delay <= 0;
        pattern <= 0;
    end else begin
        case (state)
            0: begin // idle
                if (data) begin
                    pattern <= {pattern[2:0], 1'b1};
                end else begin
                    pattern <= {pattern[2:0], 1'b0};
                end
                if (pattern == 4'b1101) begin
                    state <= 1;
                    pattern <= 0;
                end
            end
            1: begin // pattern detection
                pattern <= {pattern[2:0], data};
                if (pattern[3] == 1'b1) begin
                    delay <= {delay[2:0], pattern[0]};
                    if (pattern[3:1] == 3'b111) begin
                        state <= 2;
                        remaining_time <= delay;
                        counter <= 0;
                        counting <= 1;
                    end
                end
            end
            2: begin // counting
                counter <= counter + 1;
                if (counter == 1000) begin
                    counter <= 0;
                    remaining_time <= remaining_time - 1;
                    if (remaining_time == 0) begin
                        state <= 3;
                        counting <= 0;
                    end
                end
                count <= remaining_time;
            end
            3: begin // done
                done <= 1;
                if (ack) begin
                    state <= 0;
                    done <= 0;
                end
            end
        endcase
    end
end

endmodule