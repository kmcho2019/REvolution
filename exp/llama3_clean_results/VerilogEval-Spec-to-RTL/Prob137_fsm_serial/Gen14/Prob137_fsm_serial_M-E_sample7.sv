module TopModule(
    input clk,
    input reset,
    input in,
    output reg done
);

// Binary encoded state register
reg [1:0] state; 

// 8-bit data register
reg [7:0] data; 

// Counter to keep track of number of bits received
reg [2:0] bit_count; 

// Flag to indicate when a byte has been correctly received
reg byte_received;

always @(posedge clk) begin
    if (reset) begin
        // Reset to IDLE state
        state <= 2'b00; 
        // Reset data register
        data <= 8'b0; 
        // Reset counter
        bit_count <= 3'b0; 
        // Reset byte received flag
        byte_received <= 1'b0; 
        // Reset done signal
        done <= 1'b0; 
    end else begin
        case (state)
            2'b00: begin // IDLE state
                // Start bit detected
                if (~in) begin 
                    // Move to START state
                    state <= 2'b01; 
                    // Reset counter
                    bit_count <= 3'b1; 
                end
            end
            2'b01: begin // START state
                // Move to DATA state
                state <= 2'b10; 
            end
            2'b10: begin // DATA state
                // Shift in new bit
                data <= {data[6:0], in}; 
                // Increment counter
                bit_count <= bit_count + 1; 
                // 8 bits received
                if (bit_count == 8) begin 
                    // Move to STOP state
                    state <= 2'b11; 
                end
            end
            2'b11: begin // STOP state
                // Stop bit correct
                if (in) begin 
                    // Set byte received flag high
                    byte_received <= 1'b1; 
                    // Move back to IDLE state
                    state <= 2'b00; 
                end else begin // Stop bit incorrect
                    // Move back to IDLE state
                    state <= 2'b00; 
                end
            end
        endcase
        // Set done signal high when a byte has been correctly received
        if (byte_received) begin
            done <= 1'b1; 
            byte_received <= 1'b0; 
        end else begin
            done <= 1'b0; 
        end
    end
end

endmodule