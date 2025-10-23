module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output reg done
);

    reg [23:0] shift_reg;  // 3-byte shift register
    reg [1:0] valid_count; // Tracks how many valid bytes we have

    always @(posedge clk) begin
        if (reset) begin
            shift_reg <= 24'b0;
            valid_count <= 2'b0;
            done <= 1'b0;
        end else begin
            // Shift in new byte
            shift_reg <= {shift_reg[15:0], in};
            
            // Update valid_count
            if (shift_reg[19:16] == 4'b1000) begin  // Check bit3 of oldest byte
                valid_count <= (valid_count == 2'b10) ? 2'b0 : valid_count + 1'b1;
            end else if (in[3]) begin
                valid_count <= 2'b01;  // Start new message
            end
            
            // Generate done pulse
            done <= (valid_count == 2'b10) && (shift_reg[19:16] == 4'b1000);
        end
    end

endmodule