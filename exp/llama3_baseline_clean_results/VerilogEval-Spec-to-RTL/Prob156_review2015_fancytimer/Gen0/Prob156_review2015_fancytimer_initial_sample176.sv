module TopModule(
    input clk,
    input reset,
    input data,
    output [3:0] count,
    output counting,
    output done,
    input ack
);

reg [3:0] state; // 0: Idle, 1: Shift, 2: Counting, 3: Done
reg [3:0] delay; // Delay value
reg [3:0] current_count; // Current count
reg [9:0] counter; // Counter for counting clock cycles
reg [3:0] shift_reg; // Shift register for shifting in delay value
reg pattern_detected; // Flag to indicate if pattern 1101 is detected
reg [1:0] pattern_count; // Counter for pattern detection

always @(posedge clk) begin
    if (reset) begin
        state <= 0; // Reset to Idle state
        pattern_detected <= 0;
        pattern_count <= 0;
    end else begin
        case (state)
            0: begin // Idle state
                if (pattern_detected) begin
                    state <= 1; // Transition to Shift state
                    shift_reg <= 0; // Reset shift register
                    pattern_detected <= 0;
                    pattern_count <= 0;
                end else begin
                    if (data) begin // Check for pattern 1101
                        case (pattern_count)
                            0: if (data) pattern_count <= 1;
                            1: if (data) pattern_count <= 2;
                            2: if (~data) pattern_count <= 3;
                            3: if (data) pattern_detected <= 1;
                        endcase
                    end else begin
                        pattern_count <= 0; // Reset pattern counter
                    end
                end
            end
            1: begin // Shift state
                shift_reg <= {data, shift_reg[3:1]}; // Shift in delay value
                if (pattern_count == 4) begin
                    delay <= shift_reg; // Store delay value
                    state <= 2; // Transition to Counting state
                    current_count <= delay; // Initialize current count
                    counter <= 0; // Reset counter
                    pattern_count <= 0; // Reset pattern counter
                end else begin
                    pattern_count <= pattern_count + 1; // Increment pattern counter
                end
            end
            2: begin // Counting state
                counting <= 1; // Assert counting output
                if (counter == 1000) begin // Check if counter has reached 1000
                    counter <= 0; // Reset counter
                    current_count <= current_count - 1; // Decrement current count
                    if (current_count == 0) begin
                        state <= 3; // Transition to Done state
                    end
                end else begin
                    counter <= counter + 1; // Increment counter
                end
                count <= current_count; // Output current count
            end
            3: begin // Done state
                done <= 1; // Assert done output
                counting <= 0; // Deassert counting output
                if (ack) begin
                    state <= 0; // Transition back to Idle state
                    done <= 0; // Deassert done output
                end
            end
        endcase
    end
end

endmodule