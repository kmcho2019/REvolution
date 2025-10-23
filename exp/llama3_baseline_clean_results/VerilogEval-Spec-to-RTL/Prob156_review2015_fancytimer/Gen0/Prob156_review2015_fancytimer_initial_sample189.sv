module TopModule(
    input  clk,
    input  reset,
    input  data,
    output reg [3:0] count,
    output reg counting,
    output reg done,
    input  ack
);

reg [3:0] delay;
reg [3:0] remaining_time;
reg [9:0] clock_counter;
reg [3:0] pattern_detector;
reg detecting_pattern;
reg shifting_delay;
reg counting_down;
reg waiting_ack;

always @(posedge clk) begin
    if (reset) begin
        detecting_pattern <= 1;
        shifting_delay <= 0;
        counting_down <= 0;
        waiting_ack <= 0;
        count <= 0;
        counting <= 0;
        done <= 0;
        pattern_detector <= 0;
        delay <= 0;
        remaining_time <= 0;
        clock_counter <= 0;
    end else begin
        case ({detecting_pattern, shifting_delay, counting_down, waiting_ack})
            4'b1000: begin // Detecting pattern
                if (data == 1 && pattern_detector == 0) begin
                    pattern_detector <= 1;
                end else if (data == 1 && pattern_detector == 1) begin
                    pattern_detector <= 2;
                end else if (data == 0 && pattern_detector == 2) begin
                    pattern_detector <= 3;
                end else if (data == 1 && pattern_detector == 3) begin
                    pattern_detector <= 4;
                    detecting_pattern <= 0;
                    shifting_delay <= 1;
                end else begin
                    pattern_detector <= 0;
                end
            end
            4'b0100: begin // Shifting delay
                delay <= {data, delay[3:1]};
                if (clock_counter == 4'd3) begin
                    clock_counter <= 0;
                    shifting_delay <= 0;
                    counting_down <= 1;
                    remaining_time <= delay;
                    counting <= 1;
                end else begin
                    clock_counter <= clock_counter + 1;
                end
            end
            4'b0010: begin // Counting down
                if (clock_counter == 10'd999) begin
                    clock_counter <= 0;
                    if (remaining_time == 0) begin
                        counting_down <= 0;
                        waiting_ack <= 1;
                        done <= 1;
                    end else begin
                        remaining_time <= remaining_time - 1;
                    end
                end else begin
                    clock_counter <= clock_counter + 1;
                end
                count <= remaining_time;
            end
            4'b0001: begin // Waiting acknowledgement
                if (ack) begin
                    waiting_ack <= 0;
                    detecting_pattern <= 1;
                    done <= 0;
                    counting <= 0;
                end
            end
        endcase
    end
end

endmodule