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
reg [11:0] cycle_counter;
reg [3:0] shift_register;
reg pattern_detected;

always @(posedge clk) begin
    if (reset) begin
        // Reset the FSM to the idle state
        pattern_detected <= 1'b0;
        counting <= 1'b0;
        done <= 1'b0;
        cycle_counter <= 12'b0;
        count <= 4'b0;
        remaining_time <= 4'b0;
        shift_register <= 4'b0;
    end else begin
        // Check for the pattern 1101
        if (!pattern_detected) begin
            shift_register <= {shift_register[2:0], data};
            if (shift_register == 4'b1101) begin
                pattern_detected <= 1'b1;
            end
        end else if (count == 4'b0) begin
            // Shift in the next 4 bits to determine the delay duration
            delay <= {delay[2:0], data};
            count <= count + 1'b1;
        end else if (count == 4'b1) begin
            // Start the counting process
            counting <= 1'b1;
            remaining_time <= delay + 1'b1;
            cycle_counter <= 12'b1;
        end else if (counting) begin
            // Decrement the remaining time every 1000 clock cycles
            if (cycle_counter == 12'b1_000) begin
                remaining_time <= remaining_time - 1'b1;
                cycle_counter <= 12'b0;
            end else begin
                cycle_counter <= cycle_counter + 1'b1;
            end
            count <= remaining_time;
            if (remaining_time == 4'b0) begin
                // Counting is finished, assert done and wait for ack
                counting <= 1'b0;
                done <= 1'b1;
            end
        end else if (done) begin
            // Wait for ack to be 1
            if (ack) begin
                // Reset the FSM to the idle state
                pattern_detected <= 1'b0;
                done <= 1'b0;
                count <= 4'b0;
                remaining_time <= 4'b0;
                cycle_counter <= 12'b0;
            end
        end
    end
end

endmodule