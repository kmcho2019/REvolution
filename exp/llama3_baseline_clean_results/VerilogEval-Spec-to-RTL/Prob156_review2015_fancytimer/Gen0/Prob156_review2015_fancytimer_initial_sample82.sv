module TopModule (
    input clk,
    input reset,
    input data,
    output [3:0] count,
    output counting,
    output done,
    input ack
);

reg [3:0] delay;
reg [3:0] current_count;
reg [9:0] counter;
reg [3:0] remaining_time;
reg pattern_detected;
reg counting_state;
reg done_state;

always @(posedge clk) begin
    if (reset) begin
        pattern_detected <= 1'b0;
        counting_state <= 1'b0;
        done_state <= 1'b0;
        counter <= 10'b0;
        current_count <= 4'b0;
        remaining_time <= 4'b0;
        count <= 4'b0;
        counting <= 1'b0;
        done <= 1'b0;
    end else begin
        if (~pattern_detected) begin
            // Detect pattern 1101
            if (data == 1'b1) begin
                // Shift in data
                current_count <= {current_count[2:0], data};
                if (current_count == 4'b1101) begin
                    pattern_detected <= 1'b1;
                end
            end else begin
                current_count <= 4'b0000;
            end
        end else if (~counting_state) begin
            // Capture delay
            if (data == 1'b1) begin
                delay <= {delay[2:0], data};
                current_count <= current_count + 1'b1;
                if (current_count == 4'b1000) begin
                    counting_state <= 1'b1;
                    counter <= (delay + 1'b1) * 10'b100;
                    remaining_time <= delay;
                end
            end else begin
                delay <= {delay[2:0], data};
                current_count <= current_count + 1'b1;
                if (current_count == 4'b1000) begin
                    counting_state <= 1'b1;
                    counter <= (delay + 1'b1) * 10'b100;
                    remaining_time <= delay;
                end
            end
        end else if (counting_state) begin
            // Counting
            counter <= counter - 1'b1;
            if (counter == 10'b0) begin
                remaining_time <= remaining_time - 1'b1;
                counter <= 10'b100;
                if (remaining_time == 4'b0) begin
                    done_state <= 1'b1;
                    counting_state <= 1'b0;
                end
            end
        end else if (done_state) begin
            // Done
            if (ack) begin
                pattern_detected <= 1'b0;
                counting_state <= 1'b0;
                done_state <= 1'b0;
            end
        end
    end

    // Output logic
    if (counting_state) begin
        count <= remaining_time;
        counting <= 1'b1;
    end else begin
        counting <= 1'b0;
    end

    if (done_state) begin
        done <= 1'b1;
    end else begin
        done <= 1'b0;
    end
end

endmodule