module TopModule(
    input  clk,
    input  reset,
    input  data,
    output [3:0] count,
    output counting,
    output done,
    input  ack
);

reg [3:0] state; // 0: Idle, 1: Shift, 2: Count, 3: Done
reg [3:0] delay; // Store the delay value
reg [3:0] curr_count; // Store the current count value
reg [9:0] counter; // Counter for clock cycles
reg [3:0] shifted_data; // Store the shifted data
reg searching; // Flag to indicate if we are searching for the pattern
reg [3:0] pattern; // Store the pattern

always @(posedge clk) begin
    if (reset) begin
        state <= 0; // Reset to Idle state
        delay <= 0;
        curr_count <= 0;
        counter <= 0;
        shifted_data <= 0;
        searching <= 1;
        pattern <= 0;
        done <= 0;
        counting <= 0;
    end else begin
        case (state)
            0: begin // Idle
                if (searching) begin
                    if (data) begin
                        pattern[3] <= pattern[2];
                        pattern[2] <= pattern[1];
                        pattern[1] <= pattern[0];
                        pattern[0] <= 1;
                        if (pattern == 4'b1101) begin
                            state <= 1; // Move to Shift state
                            searching <= 0;
                        end
                    end else begin
                        pattern[3] <= pattern[2];
                        pattern[2] <= pattern[1];
                        pattern[1] <= pattern[0];
                        pattern[0] <= 0;
                    end
                end
            end
            1: begin // Shift
                if (data) begin
                    shifted_data[3] <= shifted_data[2];
                    shifted_data[2] <= shifted_data[1];
                    shifted_data[1] <= shifted_data[0];
                    shifted_data[0] <= 1;
                end else begin
                    shifted_data[3] <= shifted_data[2];
                    shifted_data[2] <= shifted_data[1];
                    shifted_data[1] <= shifted_data[0];
                    shifted_data[0] <= 0;
                end
                if (counter == 4'd4) begin
                    state <= 2; // Move to Count state
                    counter <= 0;
                    delay <= shifted_data;
                    curr_count <= delay;
                end else begin
                    counter <= counter + 1;
                end
            end
            2: begin // Count
                counting <= 1;
                if (counter == 10'd1000) begin
                    curr_count <= curr_count - 1;
                    counter <= 0;
                end else begin
                    counter <= counter + 1;
                end
                count <= curr_count;
                if (curr_count == 0) begin
                    state <= 3; // Move to Done state
                    done <= 1;
                    counting <= 0;
                end
            end
            3: begin // Done
                if (ack) begin
                    state <= 0; // Move to Idle state
                    done <= 0;
                    searching <= 1;
                end
            end
        endcase
    end
end

endmodule