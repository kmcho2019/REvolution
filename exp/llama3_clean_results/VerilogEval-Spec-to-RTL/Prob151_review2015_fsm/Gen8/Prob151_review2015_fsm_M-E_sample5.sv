module TopModule (
    input clk,
    input reset,
    input data,
    input done_counting,
    input ack,
    output reg shift_ena,
    output reg counting,
    output reg done
);

reg detect_pattern;
reg shift_enable;
reg counting_enable;
reg wait_ack;
reg [3:0] pattern;
reg [2:0] shift_cnt;
reg [3:0] duration;

always @(posedge clk) begin
    if (reset) begin
        detect_pattern <= 0;
        shift_enable <= 0;
        counting_enable <= 0;
        wait_ack <= 0;
        shift_ena <= 0;
        counting <= 0;
        done <= 0;
        pattern <= 0;
        shift_cnt <= 0;
        duration <= 0;
    end
    else begin
        // Detect pattern
        pattern <= {pattern[2:0], data};
        if (pattern == 4'b1101) begin
            detect_pattern <= 1;
        end

        // Shift operation
        if (detect_pattern && !shift_enable) begin
            shift_enable <= 1;
            shift_cnt <= 1;
            pattern <= 0;
            detect_pattern <= 0;
        end
        else if (shift_enable && shift_cnt < 4) begin
            shift_ena <= 1;
            shift_cnt <= shift_cnt + 1;
        end
        else if (shift_enable && shift_cnt == 4) begin
            shift_ena <= 0;
            shift_enable <= 0;
            counting_enable <= 1;
            duration <= {data, pattern[2:1]};
            pattern <= 0;
            shift_cnt <= 0;
        end

        // Counting operation
        if (counting_enable && !wait_ack) begin
            counting <= 1;
            if (done_counting) begin
                counting_enable <= 0;
                wait_ack <= 1;
            end
        end

        // Wait for acknowledgment
        if (wait_ack) begin
            done <= 1;
            if (ack) begin
                wait_ack <= 0;
                done <= 0;
            end
        end
    end
end

endmodule