module TopModule(
    input clk,
    input reset,
    input data,
    output reg [3:0] count,
    output reg counting,
    output reg done,
    input ack
);

reg [3:0] delay; // delay counter
reg [3:0] current_count; // current count output
reg [9:0] cycle_count; // cycle counter (10 bits for 1000 cycles)
reg [3:0] pattern_register; // register to hold the input pattern
reg start_found; // flag to indicate start pattern is found

always @(posedge clk) begin
    if (reset) begin
        // Reset to idle state
        counting <= 0;
        done <= 0;
        cycle_count <= 0;
        pattern_register <= 0;
        start_found <= 0;
        delay <= 0;
        current_count <= 0;
    end else begin
        // Idle state: searching for start pattern
        if (!start_found) begin
            pattern_register <= {pattern_register[2:0], data};
            if (pattern_register == 4'b1101) begin
                start_found <= 1;
            end
        // PatternFound state: shifting in delay
        end else if (cycle_count < 4) begin
            delay <= {delay[2:0], data};
            cycle_count <= cycle_count + 1;
            if (cycle_count == 4) begin
                start_found <= 0;
                cycle_count <= 0;
            end
        // Counting state: counting down from delay
        end else if (counting == 0) begin
            counting <= 1;
            current_count <= delay;
            cycle_count <= 0;
        end else if (cycle_count < 1000) begin
            cycle_count <= cycle_count + 1;
        end else if (current_count > 0) begin
            current_count <= current_count - 1;
            cycle_count <= 0;
        end else begin
            counting <= 0;
            done <= 1;
        end
        // Done state: waiting for ack
        if (done && ack) begin
            done <= 0;
            delay <= 0;
            current_count <= 0;
            cycle_count <= 0;
        end
    end
    count <= current_count;
end

endmodule