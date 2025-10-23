module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output reg done
);

    reg [23:0] shift_reg;  // Stores last 3 bytes
    reg [1:0] byte_count;  // Tracks how many bytes are valid in shift_reg

    always @(posedge clk) begin
        if (reset) begin
            shift_reg <= 24'b0;
            byte_count <= 2'b0;
            done <= 1'b0;
        end else begin
            // Default assignments
            done <= 1'b0;
            
            // Shift in new byte
            shift_reg <= {shift_reg[15:0], in};
            
            // Update byte count
            if (byte_count < 2'b11) begin
                byte_count <= byte_count + 1'b1;
            end
            
            // Check for complete message
            if (byte_count == 2'b11 && shift_reg[23+3]) begin  // Check in[3] of oldest byte
                done <= 1'b1;
                byte_count <= 2'b0;  // Reset for new message
            end
        end
    end

endmodule