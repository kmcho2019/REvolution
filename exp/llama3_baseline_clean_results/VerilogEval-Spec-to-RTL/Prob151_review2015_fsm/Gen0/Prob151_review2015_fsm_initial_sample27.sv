module TopModule(
    input  clk,
    input  reset,
    input  data,
    input  done_counting,
    input  ack,
    output reg shift_ena,
    output reg counting,
    output reg done
);

reg [3:0] shift_count;
reg [3:0] pattern;
reg pattern_detected;

always @(posedge clk) begin
    if (reset) begin
        shift_ena <= 0;
        counting <= 0;
        done <= 0;
        pattern_detected <= 0;
        shift_count <= 0;
        pattern <= 0;
    end else begin
        if (pattern_detected == 0) begin
            // searching for pattern 1101
            pattern <= {pattern[2:0], data};
            if (pattern == 4'b1101) begin
                pattern_detected <= 1;
                shift_count <= 0;
            end
        end else if (shift_count < 4) begin
            // shifting in 4 more bits
            shift_ena <= 1;
            shift_count <= shift_count + 1;
            if (shift_count == 3) begin
                pattern_detected <= 0;
            end
        end else if (done_counting == 0) begin
            // waiting for counters to finish counting
            shift_ena <= 0;
            counting <= 1;
        end else if (ack == 0) begin
            // notifying user and waiting for acknowledgement
            counting <= 0;
            done <= 1;
        end else begin
            // reset to IDLE state
            done <= 0;
        end
    end
end

endmodule