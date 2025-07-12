module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output reg done
);

    reg [23:0] byte_shift_reg;  // Stores last 3 bytes (MSB is oldest)
    reg [1:0] byte_count;       // Tracks how many bytes we've shifted in

    always @(posedge clk) begin
        if (reset) begin
            byte_shift_reg <= 24'b0;
            byte_count <= 2'b0;
            done <= 1'b0;
        end else begin
            // Shift in new byte
            byte_shift_reg <= {byte_shift_reg[15:0], in};
            
            // Update byte count (mod 3)
            byte_count <= (byte_count == 2'b10) ? 2'b0 : (byte_count + 1'b1);
            
            // Check for complete message every 3rd byte
            if (byte_count == 2'b10) begin
                done <= byte_shift_reg[23+3];  // Check in[3] of oldest byte
            end else begin
                done <= 1'b0;
            end
        end
    end

endmodule