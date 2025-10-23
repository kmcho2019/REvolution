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
reg [3:0] remaining_count;
reg [9:0] count_1000;
reg [3:0] state; // 0: idle, 1: detect_pattern, 2: shift_in_delay, 3: counting, 4: done
reg [3:0] pattern_detector; // 0: idle, 1: 1 detected, 2: 11 detected, 3: 110 detected, 4: 1101 detected
reg pattern_detected;

always @(posedge clk) begin
    if (reset) begin
        state <= 0;
        pattern_detector <= 0;
        pattern_detected <= 0;
        remaining_count <= 0;
        count_1000 <= 0;
        done <= 0;
        counting <= 0;
    end else begin
        case (state)
            0: begin // idle
                if (pattern_detected) begin
                    state <= 1;
                    pattern_detected <= 0;
                end
            end
            1: begin // detect_pattern
                if (data == 1) begin
                    pattern_detector <= pattern_detector + 1;
                end else begin
                    pattern_detector <= 0;
                end
                if (pattern_detector == 4) begin
                    pattern_detected <= 1;
                    state <= 2;
                    pattern_detector <= 0;
                end
            end
            2: begin // shift_in_delay
                if (count_1000 == 1000) begin
                    state <= 3;
                    count_1000 <= 0;
                    remaining_count <= delay + 1;
                    counting <= 1;
                end else if (count_1000 == 0) begin
                    case (count_1000)
                        0: delay[3] <= data;
                        100: delay[2] <= data;
                        200: delay[1] <= data;
                        300: delay[0] <= data;
                    endcase
                    count_1000 <= count_1000 + 1;
                end else begin
                    count_1000 <= count_1000 + 1;
                end
            end
            3: begin // counting
                if (count_1000 == 1000) begin
                    remaining_count <= remaining_count - 1;
                    count_1000 <= 0;
                end else begin
                    count_1000 <= count_1000 + 1;
                end
                if (remaining_count == 0) begin
                    state <= 4;
                    counting <= 0;
                    done <= 1;
                end
            end
            4: begin // done
                if (ack) begin
                    state <= 0;
                    done <= 0;
                    pattern_detector <= 0;
                    remaining_count <= 0;
                    count_1000 <= 0;
                end
            end
        endcase
    end
end

always @(posedge clk) begin
    case (state)
        3: count <= remaining_count - 1;
        default: count <= 0;
    endcase
end

always @(posedge clk) begin
    if (data == 1 && pattern_detector == 3) begin
        pattern_detected <= 1;
        pattern_detector <= 0;
        state <= 2;
    end
end

endmodule