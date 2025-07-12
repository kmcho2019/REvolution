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
reg [3:0] remaining_time;
reg [11:0] clock_counter;
reg [3:0] pattern_detector;
reg searching;

always @(posedge clk) begin
    if (reset) begin
        count <= 4'd0;
        counting <= 1'b0;
        done <= 1'b0;
        delay <= 4'd0;
        remaining_time <= 4'd0;
        clock_counter <= 12'd0;
        pattern_detector <= 4'd0;
        searching <= 1'b1;
    end else begin
        if (searching) begin
            if (pattern_detector == 4'd13) begin // 1101 in binary is 13 in decimal
                pattern_detector <= 4'd0;
                searching <= 1'b0;
                count <= 4'd0;
            end else if (data) begin
                pattern_detector <= {pattern_detector[2:0], 1'b1};
            end else begin
                pattern_detector <= {pattern_detector[2:0], 1'b0};
            end
        end else if (delay == 4'd0) begin
            delay <= {delay[2:0], data};
            if (delay == 4'd0) begin
                delay <= 4'd0;
            end else begin
                remaining_time <= delay;
                clock_counter <= 12'd0;
                counting <= 1'b1;
            end
        end else if (counting) begin
            clock_counter <= clock_counter + 1;
            if (clock_counter == 12'd999) begin
                clock_counter <= 12'd0;
                remaining_time <= remaining_time - 1;
                if (remaining_time == 4'd0) begin
                    counting <= 1'b0;
                    done <= 1'b1;
                end
            end
            count <= remaining_time;
        end else if (done) begin
            if (ack) begin
                done <= 1'b0;
                searching <= 1'b1;
            end
        end
    end
end

endmodule