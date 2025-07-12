module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output reg done
);

    reg [7:0] byte_buffer [0:2];  // 3-byte circular buffer
    reg [1:0] write_ptr;          // Pointer to current write position
    
    always @(posedge clk) begin
        if (reset) begin
            write_ptr <= 2'b00;
            done <= 1'b0;
            // Clear buffer (optional)
            byte_buffer[0] <= 8'b0;
            byte_buffer[1] <= 8'b0;
            byte_buffer[2] <= 8'b0;
        end else begin
            // Store incoming byte
            byte_buffer[write_ptr] <= in;
            
            // Update write pointer (circular)
            write_ptr <= write_ptr + 1;
            
            // Check for complete message pattern
            done <= (byte_buffer[(write_ptr + 1) % 3][3]) && 
                   (write_ptr == 2'b10);  // Only assert after 3rd byte
        end
    end

endmodule