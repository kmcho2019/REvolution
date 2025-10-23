module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output reg done
);

    // 3-byte shift register
    reg [7:0] byte_buffer [0:2];
    reg [1:0] fill_level;
    
    always @(posedge clk) begin
        if (reset) begin
            // Clear buffer and fill level
            byte_buffer[0] <= 8'b0;
            byte_buffer[1] <= 8'b0;
            byte_buffer[2] <= 8'b0;
            fill_level <= 2'b0;
            done <= 1'b0;
        end else begin
            // Shift in new byte
            byte_buffer[0] <= byte_buffer[1];
            byte_buffer[1] <= byte_buffer[2];
            byte_buffer[2] <= in;
            
            // Update fill level (saturate at 3)
            if (fill_level != 2'b11) begin
                fill_level <= fill_level + 1'b1;
            end
            
            // Check for complete message
            done <= (fill_level == 2'b11) && byte_buffer[0][3];
        end
    end

endmodule