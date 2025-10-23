module TopModule(
    input clk,
    input reset,
    input data,
    output reg [3:0] count,
    output reg counting,
    output reg done,
    input ack
);

reg [3:0] delay; // Register to hold the delay value
reg [11:0] timer; // Register to count down 1000 cycles for each delay value
reg [3:0] state; // State register ( Idle, DelayCapture, Counting, Done )
reg [3:0] pattern; // Register to hold the pattern (1101)
reg [2:0] bit_cnt; // Counter for bits in the pattern and delay

always @(posedge clk) begin
    if (reset) begin
        state <= 0; // Reset to idle state
        pattern <= 0;
        bit_cnt <= 0;
        delay <= 0;
        timer <= 0;
        count <= 0;
        counting <= 0;
        done <= 0;
    end else begin
        case (state)
            0: begin // Idle: searching for start pattern (1101)
                if (bit_cnt == 4 && pattern == 13) begin // 13 in binary is 1101
                    state <= 1; // Transition to delay capture
                    bit_cnt <= 0;
                    pattern <= 0;
                end else begin
                    pattern <= {pattern[2:0], data}; // Shift in new data
                    bit_cnt <= bit_cnt + 1;
                end
            end
            1: begin // Delay Capture: capture the 4-bit delay value
                if (bit_cnt == 4) begin
                    state <= 2; // Transition to counting
                    timer <= {delay, 12'b0}; // Set timer to (delay+1)*1000
                    count <= delay;
                    counting <= 1;
                    bit_cnt <= 0;
                end else begin
                    delay <= {delay[2:0], data}; // Shift in delay value
                    bit_cnt <= bit_cnt + 1;
                end
            end
            2: begin // Counting
                if (timer == 0) begin
                    state <= 3; // Transition to done
                    counting <= 0;
                    done <= 1;
                end else begin
                    timer <= timer - 1; // Decrement timer
                    if (timer[11:0] == 0) begin // Every 1000 cycles
                        count <= count - 1; // Decrement count
                    end
                end
            end
            3: begin // Done: wait for acknowledgement
                if (ack) begin
                    state <= 0; // Transition back to idle
                    done <= 0;
                end
            end
        endcase
    end
end

endmodule