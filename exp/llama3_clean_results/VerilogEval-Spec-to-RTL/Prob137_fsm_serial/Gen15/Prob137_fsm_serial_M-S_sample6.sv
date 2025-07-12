module TopModule(
    input clk,
    input reset,
    input in,
    output reg done
);

// 2-bit state register (IDLE, RECEIVE)
reg [1:0] state; 

// Counter to keep track of number of bits received
reg [3:0] bit_count; 

// Received data bits
reg [7:0] data;

always @(posedge clk) begin
    if (reset) begin
        // Reset to IDLE state
        state <= 2'b01; 
        // Reset counter
        bit_count <= 4'b0; 
        // Reset data
        data <= 8'b0;
        // Reset done signal
        done <= 1'b0; 
    end else begin
        case (state)
            2'b01: begin // IDLE state
                // Start bit detected
                if (~in) begin 
                    // Move to RECEIVE state
                    state <= 2'b10; 
                    // Reset counter
                    bit_count <= 4'b1; 
                    // Store start bit in data (LSB)
                    data[0] <= in;
                end
            end
            2'b10: begin // RECEIVE state
                // Increment counter
                bit_count <= bit_count + 1; 
                // Shift in new bit
                data <= {data[6:0], in};
                // 9 bits received
                if (bit_count == 9) begin 
                    // Stop bit correct
                    if (in) begin 
                        // Set done signal high
                        done <= 1'b1; 
                        // Move back to IDLE state
                        state <= 2'b01; 
                    end else begin // Stop bit incorrect
                        // Wait for stop bit
                        if (in) begin
                            state <= 2'b01;
                        end
                    end
                    // Reset counter
                    bit_count <= 4'b0; 
                end
            end
        endcase
        // Reset done signal
        if (done) begin
            done <= 1'b0; 
        end
    end
end

endmodule