module TopModule(
    input clk,
    input reset,
    input in,
    output reg done
);

reg [8:0] shift_register; // 9-bit shift register
reg [3:0] bit_count; // Counter to keep track of number of bits received

always @(posedge clk) begin
    if (reset) begin
        shift_register <= 9'b0; // Reset shift register
        bit_count <= 4'b0; // Reset counter
        done <= 1'b0; // Reset done signal
    end else begin
        if (bit_count == 4'b0 && ~in) begin // Start bit detected
            shift_register <= {8'b0, in}; // Load start bit into shift register
            bit_count <= 4'b1; // Increment counter
        end else if (bit_count < 4'b1000) begin // Receiving data bits
            shift_register <= {shift_register[7:0], in}; // Shift in new bit
            bit_count <= bit_count + 1; // Increment counter
        end else if (bit_count == 4'b1000) begin // Stop bit received
            if (in) begin // Stop bit correct
                done <= 1'b1; // Set done signal high
            end else begin // Stop bit incorrect
                shift_register <= {shift_register[7:0], in}; // Shift in new bit
            end
            if (in) begin // Stop bit detected
                bit_count <= 4'b0; // Reset counter
            end else begin
                bit_count <= bit_count + 1; // Increment counter
            end
        end else begin // Waiting for stop bit
            shift_register <= {shift_register[7:0], in}; // Shift in new bit
            bit_count <= bit_count + 1; // Increment counter
            if (in) begin // Stop bit detected
                bit_count <= 4'b0; // Reset counter
            end
        end
        if (bit_count == 4'b0 && in) begin
            done <= 1'b0; // Reset done signal
        end
    end
end

endmodule