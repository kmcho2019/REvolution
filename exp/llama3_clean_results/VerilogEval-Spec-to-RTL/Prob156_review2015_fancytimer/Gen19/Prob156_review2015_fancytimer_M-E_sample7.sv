module TopModule(
    input clk,
    input reset,
    input data,
    output reg [3:0] count,
    output reg counting,
    output reg done,
    input ack
);

reg [1:0] state; // 0: idle, 1: detect_pattern, 2: determine_delay, 3: counting, 4: done
reg [3:0] pattern_detector;
reg [3:0] delay;
reg [19:0] counter;
reg [3:0] remaining_time;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= 0;
        pattern_detector <= 0;
        delay <= 0;
        counter <= 0;
        remaining_time <= 0;
        counting <= 0;
        done <= 0;
    end else begin
        case (state)
            0: begin // idle
                if (data == 1'b1) begin
                    pattern_detector <= {pattern_detector[2:0], data};
                    if (pattern_detector == 4'b1101) begin
                        state <= 1;
                    end
                end else begin
                    pattern_detector <= {pattern_detector[2:0], data};
                end
            end
            1: begin // detect_pattern
                delay <= {data, delay[3:1]};
                state <= 2;
            end
            2: begin // determine_delay
                if (delay[0] == 1'b1) begin
                    state <= 3;
                    counter <= (delay + 1) * 1000 - 1;
                    remaining_time <= delay;
                    counting <= 1;
                end else begin
                    delay <= {data, delay[3:1]};
                end
            end
            3: begin // counting
                if (counter > 0) begin
                    counter <= counter - 1;
                    if (counter % 1000 == 0) begin
                        remaining_time <= remaining_time - 1;
                    end
                end else begin
                    counting <= 0;
                    state <= 4;
                    done <= 1;
                end
            end
            4: begin // done
                if (ack == 1'b1) begin
                    done <= 0;
                    state <= 0;
                end
            end
        endcase
    end
end

assign count = remaining_time;

endmodule