module TopModule(
    input clk,
    input reset,
    input in,
    output reg done
);

// 3-bit one-hot encoded state register
reg [2:0] state; 

// 8-bit data register
reg [7:0] data; 

// Counter to keep track of number of bits received
reg [3:0] bit_count; 

always @(posedge clk) begin
    if (reset) begin
        // Reset to IDLE state
        state <= 3'b001; 
        // Reset data register
        data <= 8'b0; 
        // Reset counter
        bit_count <= 4'b0; 
        // Reset done signal
        done <= 1'b0; 
    end else begin
        case (state)
            3'b001: begin // IDLE state
                // Start bit detected
                if (~in) begin 
                    // Move to RECEIVE state
                    state <= 3'b010; 
                    // Load start bit into data register
                    data[0] <= in; 
                    // Increment counter
                    bit_count <= 4'b1; 
                end
            end
            3'b010: begin // RECEIVE state
                // Shift in new bit
                data <= {data[6:0], in}; 
                // Increment counter
                bit_count <= bit_count + 1; 
                // 9 bits received
                if (bit_count == 9) begin 
                    // Stop bit correct
                    if (in) begin 
                        // Set done signal high
                        done <= 1'b1; 
                        // Move back to IDLE state
                        state <= 3'b001; 
                    end else begin // Stop bit incorrect
                        // Move to ERROR state
                        state <= 3'b100; 
                    end
                    // Reset counter
                    bit_count <= 4'b0; 
                end
            end
            3'b100: begin // ERROR state
                // Stop bit detected
                if (in) begin 
                    // Move back to IDLE state
                    state <= 3'b001; 
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