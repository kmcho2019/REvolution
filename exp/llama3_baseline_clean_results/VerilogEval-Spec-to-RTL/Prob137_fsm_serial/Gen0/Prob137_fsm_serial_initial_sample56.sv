module TopModule(
    input clk,
    input reset,
    input in,
    output reg done
);

reg [2:0] state; // Idle, Start, Data, Stop
reg [7:0] data; // To store the received data bits
reg [2:0] data_count; // Counter for data bits

always @(posedge clk) begin
    if (reset) begin
        state <= 3'b000; // Reset to Idle state
        done <= 0;
    end else begin
        case (state)
            3'b000: begin // Idle state
                if (!in) begin // Start bit detected
                    state <= 3'b001; // Transition to Start state
                    data_count <= 0;
                end
            end
            3'b001: begin // Start state, now collecting data
                data[data_count] <= in;
                if (data_count == 7) begin // All data bits collected
                    state <= 3'b011; // Transition to Stop state
                end else begin
                    data_count <= data_count + 1;
                end
            end
            3'b011: begin // Stop state
                if (in) begin // Stop bit detected, byte received correctly
                    done <= 1; // Signal byte received
                    state <= 3'b000; // Return to Idle state
                end else begin // Incorrect stop bit, wait for stop
                    state <= 3'b010; // Transition to wait state
                end
            end
            3'b010: begin // Waiting for stop bit
                if (in) begin // Stop bit detected, now can return to idle
                    state <= 3'b000; // Return to Idle state
                end
            end
            default: state <= 3'b000;
        endcase
    end
end

// For clarity, we reset done on the next clock cycle after it's set
always @(posedge clk) begin
    if (done) begin
        done <= 0;
    end
end

endmodule