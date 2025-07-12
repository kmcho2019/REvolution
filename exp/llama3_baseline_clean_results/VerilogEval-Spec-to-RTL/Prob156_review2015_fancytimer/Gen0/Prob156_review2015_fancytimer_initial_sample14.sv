module TopModule(
    input               clk,
    input               reset,
    input               data,
    output reg [3:0]    count,
    output reg          counting,
    output reg          done,
    input               ack
);

reg [3:0] state; // IDLE = 0, LOAD_DELAY = 1, COUNTING = 2, DONE = 3
reg [3:0] delay; // Stores the loaded delay value
reg [3:0] remaining; // Stores the remaining count value
reg [9:0] counter; // Counter for 1000 clock cycles

always @(posedge clk) begin
    if (reset) begin
        state <= 0; // Reset to IDLE state
        done <= 0;
        counting <= 0;
        count <= 0;
        counter <= 0;
        remaining <= 0;
    end else begin
        case (state)
            0: begin // IDLE
                if (data == 1'b1) begin // Pattern detection: '1' detected
                    state <= 1;
                end
            end
            1: begin // First '1' of pattern detected, now detect '1'
                if (data == 1'b1) begin // Second '1' detected
                    state <= 2;
                end else begin
                    state <= 0; // Reset pattern detection
                end
            end
            2: begin // Second '1' detected, now detect '0'
                if (data == 1'b0) begin // '0' detected
                    state <= 3;
                end else begin
                    state <= 0; // Reset pattern detection
                end
            end
            3: begin // '0' detected, now detect last '1'
                if (data == 1'b1) begin // Last '1' detected, pattern found
                    state <= 4; // Load delay
                    delay[3] <= 1'b1; // MSB of delay
                end else begin
                    state <= 0; // Reset pattern detection
                end
            end
            4: begin // Load delay
                delay[2] <= data; // Load next bit of delay
                state <= 5;
            end
            5: begin
                delay[1] <= data; // Load next bit of delay
                state <= 6;
            end
            6: begin
                delay[0] <= data; // Load last bit of delay
                state <= 7; // Start counting
                remaining <= delay + 1; // Initialize remaining count
                counting <= 1'b1; // Assert counting
            end
            7: begin // COUNTING
                if (counter == 10'd999) begin // 1000 cycles completed
                    counter <= 0;
                    if (remaining > 0) begin
                        remaining <= remaining - 1; // Decrement remaining count
                        count <= remaining; // Update count output
                    end else begin
                        state <= 8; // Done counting
                        done <= 1'b1; // Assert done
                        counting <= 1'b0; // Deassert counting
                    end
                end else begin
                    counter <= counter + 1; // Increment counter
                    count <= remaining; // Update count output
                end
            end
            8: begin // DONE
                if (ack) begin // Ack received, reset
                    state <= 0; // Reset to IDLE state
                    done <= 0;
                end
            end
            default: state <= 0;
        endcase
    end
end

endmodule