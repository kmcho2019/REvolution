module TopModule(
    input clk,
    input reset,
    input data,
    output reg [3:0] count,
    output reg counting,
    output reg done,
    input ack
);

reg [3:0] delay;
reg [3:0] remaining_count;
reg [9:0] timer;
reg [3:0] pattern_detector;

always @ (posedge clk) begin
    if (reset) begin
        pattern_detector <= 0;
        delay <= 0;
        remaining_count <= 0;
        timer <= 0;
        counting <= 0;
        done <= 0;
    end else begin
        case (pattern_detector)
            0: begin
                if (data) begin
                    pattern_detector <= 8;
                end
            end
            8: begin
                if (data) begin
                    pattern_detector <= 12;
                end else begin
                    pattern_detector <= 0;
                end
            end
            12: begin
                if (~data) begin
                    pattern_detector <= 9;
                end else begin
                    pattern_detector <= 0;
                end
            end
            9: begin
                if (~data) begin
                    pattern_detector <= 1;
                    delay <= 0;
                end else begin
                    pattern_detector <= 0;
                end
            end
            1: begin
                delay[3] <= data;
                pattern_detector <= 2;
            end
            2: begin
                delay[2] <= data;
                pattern_detector <= 3;
            end
            3: begin
                delay[1] <= data;
                pattern_detector <= 4;
            end
            4: begin
                delay[0] <= data;
                remaining_count <= delay + 1;
                timer <= 1000;
                counting <= 1;
                pattern_detector <= 5;
            end
            5: begin
                if (timer == 0) begin
                    remaining_count <= remaining_count - 1;
                    if (remaining_count > 0) begin
                        timer <= 1000;
                    end else begin
                        counting <= 0;
                        done <= 1;
                        pattern_detector <= 6;
                    end
                end else begin
                    timer <= timer - 1;
                end
            end
            6: begin
                if (ack) begin
                    done <= 0;
                    pattern_detector <= 0;
                end
            end
        endcase
    end
end

always @ (posedge clk) begin
    if (pattern_detector == 5) begin
        count <= remaining_count;
    end else begin
        count <= 0;
    end
end

endmodule